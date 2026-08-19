import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_prefs.dart';
import '../../../core/storage/storage_keys.dart';
import '../data/content_repository.dart';
import '../data/models/content_list_response.dart';
import '../domain/content_item.dart';
import '../domain/content_type.dart';

/// Loads the cached `content_list.json` immediately (if present) while
/// refreshing from the network in the background — mirrors the original
/// app's `GetContactsOffline`/`GetContactsOnline` two-phase load, but
/// collapsed into one code path (the original duplicated this logic in
/// both `ContentManager` and `MenuFragment`).
class ContentListNotifier extends AsyncNotifier<ContentListResponse> {
  @override
  Future<ContentListResponse> build() async {
    final repo = ref.watch(contentRepositoryProvider);
    final cached = await repo.readCache();
    if (cached != null) {
      unawaited(_refreshInBackground());
      return cached;
    }
    return repo.fetchAndCache();
  }

  Future<void> _refreshInBackground() async {
    try {
      final fresh = await ref.read(contentRepositoryProvider).fetchAndCache();
      state = AsyncData(fresh);
    } catch (_) {
      // Keep serving the cached copy if the network refresh fails.
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading<ContentListResponse>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(contentRepositoryProvider).fetchAndCache());
  }
}

final contentListProvider = AsyncNotifierProvider<ContentListNotifier, ContentListResponse>(
  ContentListNotifier.new,
);

/// Items of one [ContentType], derived from [contentListProvider].
final contentItemsProvider =
    Provider.family<AsyncValue<List<ContentItem>>, ContentType>((ref, type) {
  final async = ref.watch(contentListProvider);
  final repo = ref.watch(contentRepositoryProvider);
  return async.whenData((response) => repo.itemsForType(response, type));
});

/// Set of favorited content `folder` names, backed by SharedPreferences
/// (`favorite_contents`), matching `ContentManager.favoriteContent`.
class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getStringList(StorageKeys.favoriteContents)?.toSet() ?? <String>{};
  }

  void toggle(String folder) {
    final updated = {...state};
    if (!updated.remove(folder)) updated.add(folder);
    state = updated;
    ref.read(sharedPreferencesProvider).setStringList(
          StorageKeys.favoriteContents,
          updated.toList(),
        );
  }

  bool isFavorite(String folder) => state.contains(folder);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);
