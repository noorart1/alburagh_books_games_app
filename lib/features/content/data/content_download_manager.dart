import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/network/dio_client.dart';
import '../domain/content_item.dart';

/// Progress of an in-flight content download, 0.0–1.0. `null` means
/// "extracting" (the zip finished downloading but hasn't been unpacked yet).
typedef ContentDownloadProgress = double?;

/// Manages content downloading, offline extraction, asset bundled content
/// synchronization, and manual file/folder import.
class ContentDownloadManager {
  ContentDownloadManager(this._dio);

  final Dio _dio;
  final _progressControllers =
      <String, StreamController<ContentDownloadProgress>>{};

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

  Future<Directory> contentDirForFolder(String folder) async {
    final root = await contentRootDir();
    return Directory('${root.path}/$folder');
  }

  /// A content item is considered downloaded once its manifest
  /// (`content.json`) exists on disk, or if it has a pre-bundled asset.
  Future<bool> isDownloaded(ContentItem item) async {
    final dir = await contentDir(item);
    if (File('${dir.path}/content.json').existsSync()) {
      return true;
    }

    // Check if the item is pre-bundled in assets/contents/<folder>.zip
    if (await _hasBundledAsset(item.folder)) {
      final extracted = await _extractBundledAsset(item.folder, dir);
      if (extracted) return true;
    }

    return false;
  }

  Stream<ContentDownloadProgress> progressStream(String folder) =>
      (_progressControllers[folder] ??=
              StreamController<ContentDownloadProgress>.broadcast())
          .stream;

  Future<void> delete(ContentItem item) async {
    final dir = await contentDir(item);
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  final _inFlight = <String, Future<void>>{};

  bool isDownloading(ContentItem item) => _inFlight.containsKey(item.folder);

  /// Tapping download again (from the card, or a reopened popup) while one is
  /// running joins that download instead of starting a second one into the
  /// same zip/folder.
  ///
  /// The callback must not be an `=>`: `remove` returns this very future, and a
  /// `whenComplete` callback that returns a future is awaited — it would wait
  /// on itself forever, so callers' `await download()` would never resume.
  Future<void> download(ContentItem item) => _inFlight[item.folder] ??=
      _download(item).whenComplete(() {
        _inFlight.remove(item.folder);
      });

  Future<void> _download(ContentItem item) async {
    final controller = _progressControllers[item.folder] ??=
        StreamController<ContentDownloadProgress>.broadcast();
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

  /// Extracts a local zip file from disk into app contents storage.
  Future<Directory> importZipFile(
    File zipFile, {
    String? targetFolderName,
  }) async {
    final folder = targetFolderName ?? _sanitizedFolderName(zipFile.path);
    final targetDir = await contentDirForFolder(folder);
    if (targetDir.existsSync()) await targetDir.delete(recursive: true);
    targetDir.createSync(recursive: true);

    await extractFileToDisk(zipFile.path, targetDir.path);
    _flattenIfSingleNestedDirectory(targetDir);

    final manifestFile = File('${targetDir.path}/content.json');
    if (!manifestFile.existsSync()) {
      throw FormatException(
        'ملف content.json غير موجود في الحزمة المضغوطة ($folder)',
      );
    }

    return targetDir;
  }

  /// Copies an existing directory into app contents storage.
  Future<Directory> importFolder(
    Directory sourceDir, {
    String? targetFolderName,
  }) async {
    final folder = targetFolderName ?? _sanitizedFolderName(sourceDir.path);
    final targetDir = await contentDirForFolder(folder);
    if (targetDir.existsSync()) await targetDir.delete(recursive: true);
    targetDir.createSync(recursive: true);

    await _copyDirectory(sourceDir, targetDir);
    _flattenIfSingleNestedDirectory(targetDir);

    final manifestFile = File('${targetDir.path}/content.json');
    if (!manifestFile.existsSync()) {
      throw FormatException('ملف content.json غير موجود في المجلد ($folder)');
    }

    return targetDir;
  }

  Future<bool> _hasBundledAsset(String folder) async {
    try {
      await rootBundle.load('assets/contents/$folder.zip');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _extractBundledAsset(String folder, Directory targetDir) async {
    try {
      final byteData = await rootBundle.load('assets/contents/$folder.zip');
      final bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
      final archive = ZipDecoder().decodeBytes(bytes);

      if (targetDir.existsSync()) await targetDir.delete(recursive: true);
      targetDir.createSync(recursive: true);

      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final outFile = File('${targetDir.path}/$filename');
          outFile.parent.createSync(recursive: true);
          outFile.writeAsBytesSync(file.content as List<int>);
        } else {
          Directory('${targetDir.path}/$filename').createSync(recursive: true);
        }
      }
      _flattenIfSingleNestedDirectory(targetDir);
      return File('${targetDir.path}/content.json').existsSync();
    } catch (_) {
      return false;
    }
  }

  void _flattenIfSingleNestedDirectory(Directory dir) {
    if (File('${dir.path}/content.json').existsSync()) return;

    // If zip had a root folder (e.g. folder/content.json instead of ./content.json)
    final entities = dir.listSync();
    final dirs = entities.whereType<Directory>().toList();
    if (dirs.length == 1 && entities.length == 1) {
      final sub = dirs.first;
      final subManifest = File('${sub.path}/content.json');
      if (subManifest.existsSync()) {
        for (final item in sub.listSync()) {
          final itemName = item.uri.pathSegments
              .where((s) => s.isNotEmpty)
              .last;
          if (item is File) {
            item.renameSync('${dir.path}/$itemName');
          } else if (item is Directory) {
            item.renameSync('${dir.path}/$itemName');
          }
        }
        try {
          sub.deleteSync(recursive: true);
        } catch (_) {}
      }
    }
  }

  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await for (final entity in source.list(recursive: false)) {
      final name = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;
      if (entity is Directory) {
        final newDirectory = Directory('${destination.path}/$name');
        await newDirectory.create(recursive: true);
        await _copyDirectory(entity, newDirectory);
      } else if (entity is File) {
        await entity.copy('${destination.path}/$name');
      }
    }
  }

  String _sanitizedFolderName(String path) {
    final name = path.replaceAll('\\', '/').split('/').last;
    return name
        .replaceAll(RegExp(r'\.zip$', caseSensitive: false), '')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
  }
}

final contentDownloadManagerProvider = Provider<ContentDownloadManager>(
  (ref) => ContentDownloadManager(ref.watch(dioProvider)),
);
