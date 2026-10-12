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
    // `window.alburagh` is injected into every page by [LocalContentServer].
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('alburaghBridge', onMessageReceived: _onBridgeMessage)
      ..setOnConsoleMessage((m) => debugPrint('[content ${m.level.name}] ${m.message}'));
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
    _stopPageAudio(); // the previous page's narration/effects mustn't play over the new page
    await _controller.loadRequest(pageUri);
  }

  /// Background music is left running: books start it once on page 0
  /// (`play_music('fx/music.mp3', .3)`) and expect it across pages, until
  /// `stop_music()` or the player closes.
  void _stopPageAudio() {
    _narration.stop();
    for (final player in _soundPlayers.values) {
      player.dispose();
    }
    _soundPlayers.clear();
  }

  void _onBridgeMessage(JavaScriptMessage message) {
    final Map<String, dynamic> call = jsonDecode(message.message) as Map<String, dynamic>;
    final method = call['method'] as String;
    final args = call['args'] as List<dynamic>;
    // Content often omits the volume (`play_narration('1/media/01.mp3')`),
    // which arrives as null/missing — default to full volume.
    final volume = args.length > 1 && args[1] is num ? (args[1] as num).toDouble() : 1.0;
    switch (method) {
      case 'openPage':
        _loadPage(int.parse('${args[0]}'));
      case 'bookExit':
        if (mounted) context.pop();
      case 'playMusic':
        _playMusic(args[0] as String, volume);
      case 'stopMusic':
        _musicPath = null;
        _music.stop();
      case 'playNarration':
        _play(_narration, args[0] as String, volume);
      case 'stopNarration':
        _narration.stop();
      case 'playSound':
        _playSound(args[0] as String, volume);
      case 'bookFinished':
        break;
    }
  }

  String _resolveAssetPath(String relativePath) => '${_contentDir!.path}/$relativePath';

  /// Content sometimes references audio missing from its zip (e.g. a page asks
  /// for `1/media/001.mp3` but ships only `01.mp3`) — skip those quietly, like
  /// the original app, instead of throwing and breaking the page's other audio.
  bool _exists(String relativePath) {
    if (File(_resolveAssetPath(relativePath)).existsSync()) return true;
    debugPrint('[content audio] missing: $relativePath');
    return false;
  }

  void _play(AudioPlayer player, String relativePath, double volume) {
    if (!_exists(relativePath)) return;
    player
        .play(DeviceFileSource(_resolveAssetPath(relativePath)), volume: volume)
        .catchError((Object e) => debugPrint('[content audio] $relativePath: $e'));
  }

  String? _musicPath;

  /// A page re-requesting the music that's already playing keeps it going
  /// rather than restarting it from the top.
  void _playMusic(String relativePath, double volume) {
    if (relativePath == _musicPath && _music.state == PlayerState.playing) {
      _music.setVolume(volume);
      return;
    }
    _musicPath = relativePath;
    _play(_music, relativePath, volume);
  }

  void _playSound(String relativePath, double volume) {
    if (!_exists(relativePath)) return;
    final player = _soundPlayers.putIfAbsent(relativePath, () {
      final p = AudioPlayer();
      p.onPlayerComplete.listen((_) => _soundPlayers.remove(relativePath)?.dispose());
      return p;
    });
    _play(player, relativePath, volume);
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
