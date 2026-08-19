import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/network/dio_client.dart';
import '../domain/content_item.dart';

/// Progress of an in-flight content download, 0.0–1.0. `null` means
/// "extracting" (the zip finished downloading but hasn't been unpacked yet).
typedef ContentDownloadProgress = double?;

/// Downloads a content zip and extracts it to app-local storage, mirroring
/// `DownloadManager`/`AppHelper.extractBookZipFile` in the original app —
/// but using `path_provider` app-support storage instead of the legacy
/// unscoped `Android/data/<pkg>/contents` external-storage path (which
/// relies on `requestLegacyExternalStorage` and won't work on modern
/// Android/iOS).
///
/// The original app rendered pages by loading `file://` URLs straight into
/// a WebView with a JS bridge — no local HTTP server. We keep that same
/// approach here; the extracted folder is later opened directly by the
/// content player via `file://<contentDir>/<folder>/...`.
class ContentDownloadManager {
  ContentDownloadManager(this._dio);

  final Dio _dio;
  final _progressControllers = <String, StreamController<ContentDownloadProgress>>{};

  Future<Directory> contentRootDir() async {
    final dir = await getApplicationSupportDirectory();
    final contentDir = Directory('${dir.path}/contents');
    if (!contentDir.existsSync()) contentDir.createSync(recursive: true);
    return contentDir;
  }

  Future<Directory> contentDir(ContentItem item) async {
    final root = await contentRootDir();
    return Directory('${root.path}/${item.folder}');
  }

  /// A content item is considered downloaded once its manifest
  /// (`content.json`) exists, matching `ContentManager.isContentDownloaded`.
  Future<bool> isDownloaded(ContentItem item) async {
    final dir = await contentDir(item);
    return File('${dir.path}/content.json').existsSync();
  }

  Stream<ContentDownloadProgress> progressStream(String folder) =>
      (_progressControllers[folder] ??= StreamController<ContentDownloadProgress>.broadcast()).stream;

  Future<void> delete(ContentItem item) async {
    final dir = await contentDir(item);
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  Future<void> download(ContentItem item) async {
    final controller =
        _progressControllers[item.folder] ??= StreamController<ContentDownloadProgress>.broadcast();
    final root = await contentRootDir();
    final zipPath = '${root.path}/${item.folder}.zip';

    try {
      controller.add(0);
      await _dio.download(
        item.fileUrl,
        zipPath,
        onReceiveProgress: (received, total) {
          if (total > 0) controller.add(received / total);
        },
      );

      controller.add(null); // extracting
      final targetDir = await contentDir(item);
      if (targetDir.existsSync()) await targetDir.delete(recursive: true);
      targetDir.createSync(recursive: true);

      await extractFileToDisk(zipPath, targetDir.path);
      await File(zipPath).delete();

      controller.add(1);
    } finally {
      await controller.close();
      _progressControllers.remove(item.folder);
    }
  }
}

final contentDownloadManagerProvider = Provider<ContentDownloadManager>(
  (ref) => ContentDownloadManager(ref.watch(dioProvider)),
);
