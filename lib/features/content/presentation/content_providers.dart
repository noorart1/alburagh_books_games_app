import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_prefs.dart';
import '../../../core/storage/storage_keys.dart';
import '../data/content_download_manager.dart';
import '../data/content_repository.dart';
import '../data/models/content_list_response.dart';
import '../domain/content_item.dart';
import '../domain/content_type.dart';
import '../domain/local_custom_item.dart';

/// Loads the cached `content_list.json` immediately (if present) or falls back
/// to bundled `assets/data/content_list.json` when offline, while refreshing
/// from network in background if available.
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
      ref.read(isOnlineProvider.notifier).state = true;
    } catch (_) {
      // Keep serving the cached/bundled copy if the network refresh fails.
      ref.read(isOnlineProvider.notifier).state = false;
    }
  }

  /// Re-checks the website; on failure the cached/bundled list stays visible.
  Future<void> refresh() => _refreshInBackground();
}

final contentListProvider = AsyncNotifierProvider<ContentListNotifier, ContentListResponse>(
  ContentListNotifier.new,
);

/// Whether the last content-list fetch from the website succeeded.
/// ponytail: inferred from the API call, add connectivity_plus if live network changes must be detected.
final isOnlineProvider = StateProvider<bool>((ref) => true);

/// Custom offline imported items (stored in app support storage).
class CustomItemsNotifier extends AsyncNotifier<List<LocalCustomItem>> {
  @override
  Future<List<LocalCustomItem>> build() async {
    return ref.watch(contentRepositoryProvider).getCustomItems();
  }

  Future<void> addCustomItem(LocalCustomItem item) async {
    await ref.read(contentRepositoryProvider).saveCustomItem(item);
    ref.invalidateSelf();
  }

  Future<void> removeCustomItem(String folder) async {
    await ref.read(contentRepositoryProvider).removeCustomItem(folder);
    ref.invalidateSelf();
  }
}

final customItemsProvider = AsyncNotifierProvider<CustomItemsNotifier, List<LocalCustomItem>>(
  CustomItemsNotifier.new,
);

/// Whether to show only downloaded/offline-ready items in the content grid.
final downloadedOnlyFilterProvider = StateProvider<bool>((ref) => false);

/// Items of one [ContentType], derived from [contentListProvider] and [customItemsProvider].
final contentItemsProvider =
    Provider.family<AsyncValue<List<ContentItem>>, ContentType>((ref, type) {
  final async = ref.watch(contentListProvider);
  final repo = ref.watch(contentRepositoryProvider);
  final customItems = ref.watch(customItemsProvider).value ?? const [];

  return async.whenData((response) => repo.itemsForType(response, type, customItems: customItems));
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
