import 'dart:convert';
import 'dart:io';

/// Serves a downloaded content folder over `http://127.0.0.1:<port>` so the
/// WebView loads it as a normal same-origin site instead of a `file://` URL.
///
/// The original app loaded content straight from `file://` in its WebView.
/// We tried the same here first, but `webview_flutter_android` doesn't
/// expose Android's `setAllowFileAccessFromFileURLs`, so Construct2-exported
/// games (which `XMLHttpRequest` their own `data.js` at runtime) silently
/// fail to load any assets under `file://`. Serving over loopback HTTP
/// avoids the restriction entirely — pages made of `<script src>`/`fetch`/
/// `XMLHttpRequest` all just see a normal same-origin server, which is
/// exactly what the original spec called for (zip → extract → local HTTP
/// server → WebView).
class LocalContentServer {
  HttpServer? _server;
  String? _servedPath;

  /// Starts serving [root] (idempotent: reuses the running server if it's
  /// already serving this exact folder) and returns its base URI.
  Future<Uri> serve(Directory root) async {
    if (_server != null && _servedPath == root.path) {
      return Uri(scheme: 'http', host: '127.0.0.1', port: _server!.port);
    }
    await close();

    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server = server;
    _servedPath = root.path;
    server.listen((request) => _handle(request, root));
    return Uri(scheme: 'http', host: '127.0.0.1', port: server.port);
  }

  Future<void> _handle(HttpRequest request, Directory root) async {
    final relativePath = request.uri.pathSegments.join('/');
    final file = File('${root.path}/$relativePath');
    if (!await file.exists()) {
      // Content often references files its zip doesn't ship (pathfind.js,
      // audio); a 404 body then fails e.g. Web Audio decoding — log which.
      print('[content 404] $relativePath'); // ignore: avoid_print
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }
    final contentType = _contentTypeFor(file.path);
    request.response.headers.contentType = contentType;
    if (contentType == ContentType.html) {
      // Define the bridge before any page script runs: content calls
      // `alburagh.playNarration(...)` from `init_page()` during load, which
      // an onPageFinished injection is too late for.
      final html = utf8.decode(await file.readAsBytes(), allowMalformed: true);
      request.response.write(_injectBridge(html));
    } else {
      await request.response.addStream(file.openRead());
    }
    await request.response.close();
  }

  static String _injectBridge(String html) {
    final head = RegExp('<head[^>]*>', caseSensitive: false).firstMatch(html);
    return head == null
        ? '$bridgeScript$html'
        : html.replaceRange(head.end, head.end, bridgeScript);
  }

  /// `window.alburagh` — the Android JS interface the content's `alburagh.js`
  /// calls, forwarded to the `alburaghBridge` JavaScript channel as JSON.
  static const bridgeScript = '''
<script>
(function () {
  function call(method) {
    return function () {
      alburaghBridge.postMessage(JSON.stringify({method: method, args: Array.prototype.slice.call(arguments)}));
    };
  }
  window.alburagh = {};
  ['openPage', 'bookFinished', 'bookExit', 'playMusic', 'stopMusic',
   'playNarration', 'stopNarration', 'playSound'].forEach(function (m) { window.alburagh[m] = call(m); });
})();
</script>
''';

  ContentType _contentTypeFor(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'html':
      case 'htm':
        return ContentType.html;
      case 'js':
        return ContentType('application', 'javascript');
      case 'css':
        return ContentType('text', 'css');
      case 'json':
        return ContentType.json;
      case 'png':
        return ContentType('image', 'png');
      case 'jpg':
      case 'jpeg':
        return ContentType('image', 'jpeg');
      case 'gif':
        return ContentType('image', 'gif');
      case 'svg':
        return ContentType('image', 'svg+xml');
      case 'webp':
        return ContentType('image', 'webp');
      case 'mp3':
        return ContentType('audio', 'mpeg');
      case 'ogg':
        return ContentType('audio', 'ogg');
      case 'wav':
        return ContentType('audio', 'wav');
      case 'mp4':
      case 'm4a':
        return ContentType('audio', 'mp4');
      case 'woff':
        return ContentType('font', 'woff');
      case 'woff2':
        return ContentType('font', 'woff2');
      case 'ttf':
        return ContentType('font', 'ttf');
      default:
        return ContentType.binary;
    }
  }

  Future<void> close() async {
    await _server?.close(force: true);
    _server = null;
    _servedPath = null;
  }
}
