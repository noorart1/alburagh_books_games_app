import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/content_item.dart';
import '../domain/content_type.dart';
import 'content_api.dart';
import 'models/content_list_response.dart';

/// Caches `content_list.json` on disk and serves it immediately while a
/// background refresh happens, mirroring `ContentManager.getContentList()`
/// in the original app (cached copy first, then overwrite from network).
class ContentRepository {
  ContentRepository(this._api);

  final ContentApi _api;
  static const _cacheFileName = 'content_list.json';

  Future<File> _cacheFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_cacheFileName');
  }

  Future<ContentListResponse?> readCache() async {
    try {
      final file = await _cacheFile();
      if (!file.existsSync()) return null;
      final raw = await file.readAsString();
      return ContentListResponse.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<ContentListResponse> fetchAndCache() async {
    final response = await _api.getContentList();
    final file = await _cacheFile();
    await file.writeAsString(jsonEncode(_responseToJson(response)));
    return response;
  }

  Map<String, dynamic> _responseToJson(ContentListResponse response) => {
        'books': response.books.map((e) => e.toJson()).toList(),
        'games': response.games.map((e) => e.toJson()).toList(),
        'qurans': response.qurans.map((e) => e.toJson()).toList(),
        'sound_books': response.soundBooks.map((e) => e.toJson()).toList(),
      };

  List<ContentItem> itemsForType(ContentListResponse response, ContentType type) {
    switch (type) {
      case ContentType.book:
        return response.books;
      case ContentType.game:
        return response.games;
      case ContentType.quran:
        return response.qurans;
      case ContentType.soundBook:
        return response.soundBooks;
    }
  }
}

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => ContentRepository(ref.watch(contentApiProvider)),
);
