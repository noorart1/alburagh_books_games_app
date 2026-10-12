import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/content_item.dart';
import '../domain/content_type.dart';
import '../domain/local_custom_item.dart';
import 'content_api.dart';
import 'models/content_list_response.dart';

/// Caches `content_list.json` on disk and serves it immediately while a
/// background refresh happens. Also falls back to bundled asset
/// `assets/data/content_list.json` when launched completely offline,
/// and persists custom imported offline items in `custom_contents.json`.
class ContentRepository {
  ContentRepository(this._api);

  final ContentApi _api;
  static const _cacheFileName = 'content_list.json';
  static const _customItemsFileName = 'custom_contents.json';

  Future<File> _cacheFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_cacheFileName');
  }

  Future<File> _customItemsFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_customItemsFileName');
  }

  /// Disk cache first; if it's missing or unreadable, the bundled catalog.
  Future<ContentListResponse?> readCache() async {
    try {
      final file = await _cacheFile();
      if (file.existsSync()) return ContentApi.parseContentList(await file.readAsString());
    } catch (_) {
      // Corrupt/old-format cache: fall through to the bundled copy.
    }
    try {
      return ContentApi.parseContentList(
        await rootBundle.loadString('assets/data/content_list.json'),
      );
    } catch (_) {
      return null;
    }
  }

  Future<ContentListResponse> fetchAndCache() async {
    final raw = await _api.getContentListRaw();
    final response = ContentApi.parseContentList(raw); // validate before caching
    await (await _cacheFile()).writeAsString(raw);
    return response;
  }

  Future<List<LocalCustomItem>> getCustomItems() async {
    try {
      final file = await _customItemsFile();
      if (!file.existsSync()) return [];
      final raw = await file.readAsString();
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => LocalCustomItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCustomItem(LocalCustomItem item) async {
    final items = await getCustomItems();
    final existingIndex = items.indexWhere((i) => i.folder == item.folder);
    if (existingIndex >= 0) {
      items[existingIndex] = item;
    } else {
      items.insert(0, item);
    }
    final file = await _customItemsFile();
    await file.writeAsString(jsonEncode(items.map((i) => i.toJson()).toList()));
  }

  Future<void> removeCustomItem(String folder) async {
    final items = await getCustomItems();
    items.removeWhere((i) => i.folder == folder);
    final file = await _customItemsFile();
    await file.writeAsString(jsonEncode(items.map((i) => i.toJson()).toList()));
  }

  List<ContentItem> itemsForType(
    ContentListResponse response,
    ContentType type, {
    List<LocalCustomItem> customItems = const [],
  }) {
    List<ContentItem> baseItems;
    switch (type) {
      case ContentType.book:
        baseItems = List<ContentItem>.from(response.books);
      case ContentType.game:
        baseItems = List<ContentItem>.from(response.games);
      case ContentType.quran:
        baseItems = List<ContentItem>.from(response.qurans);
      case ContentType.soundBook:
        baseItems = List<ContentItem>.from(response.soundBooks);
    }

    final matchingCustom = customItems.where((c) => c.contentType == type).toList();
    if (matchingCustom.isEmpty) return baseItems;

    // Prepend or merge custom items
    final folderSet = baseItems.map((e) => e.folder).toSet();
    final uniqueCustom = matchingCustom.where((c) => !folderSet.contains(c.folder)).toList();
    return [...uniqueCustom, ...baseItems];
  }
}

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => ContentRepository(ref.watch(contentApiProvider)),
);
