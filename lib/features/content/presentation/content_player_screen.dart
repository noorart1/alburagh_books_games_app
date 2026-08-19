import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/content_download_manager.dart';
import '../data/content_manifest.dart';
import '../data/local_content_server.dart';
import '../domain/content_item.dart';

/// Renders downloaded content (book pages / games / Quran / sound books) —
/// mirrors `ContentFragment`'s WebView + JS-bridge pipeline: the extracted
/// folder's `content.json` names the entry HTML file(s), served over a
/// loopback HTTP server ([LocalContentServer]) with a JS bridge
/// (`window.alburagh`) exposing page navigation, exit, and audio playback
/// to the web content.
class ContentPlayerScreen extends ConsumerStatefulWidget {
  const ContentPlayerScreen({required this.item, super.key});

  final ContentItem item;

  @override
  ConsumerState<ContentPlayerScreen> createState() => _ContentPlayerScreenState();
}

class _ContentPlayerScreenState extends ConsumerState<ContentPlayerScreen> {
  late final WebViewController _controller;
  final _music = AudioPlayer()..setReleaseMode(ReleaseMode.loop);
  final _narration = AudioPlayer();
  final _soundPlayers = <String, AudioPlayer>{};
  final _server = LocalContentServer();

  Directory? _contentDir;
  Uri? _baseUri;
  ContentManifest? _manifest;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('alburaghBridge', onMessageReceived: _onBridgeMessage)
      ..setNavigationDelegate(
        NavigationDelegate(onPageFinished: (_) => _injectBridgeShim()),
      );
    _init();
  }

  Future<void> _init() async {
    try {
      final dir = await ref.read(contentDownloadManagerProvider).contentDir(widget.item);
      final manifest = await loadContentManifest(dir, widget.item.contentType);
      final baseUri = await _server.serve(dir);
      if (!mounted) return;
      setState(() {
        _contentDir = dir;
        _baseUri = baseUri;
        _manifest = manifest;
        _loading = false;
      });
      await _loadPage(0);
    } catch (_) {
      if (mounted) setState(() { _error = 'تعذّر فتح المحتوى'; _loading = false; });
    }
  }

  Future<void> _loadPage(int index) async {
    final manifest = _manifest;
    final baseUri = _baseUri;
    if (manifest == null || baseUri == null) return;
    if (manifest.isPaged && (index < 0 || index >= manifest.pages!.length)) return;
    final relativeHtml = manifest.isPaged ? manifest.pages![index].html : manifest.html!;
    final pageUri = baseUri.replace(pathSegments: relativeHtml.split('/'));
    await _controller.loadRequest(pageUri);
  }

  Future<void> _injectBridgeShim() async {
    await _controller.runJavaScript('''
      window.alburagh = {
        openPage: function(i) { alburaghBridge.postMessage(JSON.stringify({method:"openPage", args:[i]})); },
        bookFinished: function() { alburaghBridge.postMessage(JSON.stringify({method:"bookFinished", args:[]})); },
        bookExit: function() { alburaghBridge.postMessage(JSON.stringify({method:"bookExit", args:[]})); },
        playMusic: function(p, v) { alburaghBridge.postMessage(JSON.stringify({method:"playMusic", args:[p, v]})); },
        stopMusic: function() { alburaghBridge.postMessage(JSON.stringify({method:"stopMusic", args:[]})); },
        playNarration: function(p, v) { alburaghBridge.postMessage(JSON.stringify({method:"playNarration", args:[p, v]})); },
        stopNarration: function() { alburaghBridge.postMessage(JSON.stringify({method:"stopNarration", args:[]})); },
        playSound: function(p, v) { alburaghBridge.postMessage(JSON.stringify({method:"playSound", args:[p, v]})); }
      };
    ''');
  }

  void _onBridgeMessage(JavaScriptMessage message) {
    final Map<String, dynamic> call = jsonDecode(message.message) as Map<String, dynamic>;
    final method = call['method'] as String;
    final args = call['args'] as List<dynamic>;
    switch (method) {
      case 'openPage':
        _loadPage(args[0] as int);
      case 'bookExit':
        if (mounted) context.pop();
      case 'playMusic':
        _music.play(DeviceFileSource(_resolveAssetPath(args[0] as String)), volume: (args[1] as num).toDouble());
      case 'stopMusic':
        _music.stop();
      case 'playNarration':
        _narration.play(DeviceFileSource(_resolveAssetPath(args[0] as String)), volume: (args[1] as num).toDouble());
      case 'stopNarration':
        _narration.stop();
      case 'playSound':
        _playSound(args[0] as String, (args[1] as num).toDouble());
      case 'bookFinished':
        break;
    }
  }

  String _resolveAssetPath(String relativePath) => '${_contentDir!.path}/$relativePath';

  void _playSound(String relativePath, double volume) {
    final player = _soundPlayers.putIfAbsent(relativePath, () {
      final p = AudioPlayer();
      p.onPlayerComplete.listen((_) => _soundPlayers.remove(relativePath)?.dispose());
      return p;
    });
    player.play(DeviceFileSource(_resolveAssetPath(relativePath)), volume: volume);
  }

  @override
  void dispose() {
    _music.dispose();
    _narration.dispose();
    for (final player in _soundPlayers.values) {
      player.dispose();
    }
    _server.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop())),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: WebViewWidget(controller: _controller)),
            Positioned(
              top: 8,
              right: 8,
              child: _PlayerButton(icon: Icons.close, onTap: () => context.pop()),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerButton extends StatelessWidget {
  const _PlayerButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(10), child: Icon(icon)),
      ),
    );
  }
}
