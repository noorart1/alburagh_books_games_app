import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/content_download_manager.dart';
import '../domain/content_item.dart';
import '../domain/content_type.dart';
import 'book_detail_screen.dart';
import 'content_providers.dart';
import 'storage_browser_dialog.dart';

const _categoryTitles = {
  ContentType.book: 'القصص التفاعلية',
  ContentType.game: 'الألعاب التعليمية',
  ContentType.quran: 'القرآن الكريم',
  ContentType.soundBook: 'الكتب الصوتية',
};

/// The grid of content cards for one category.
/// Supports offline filtering, bundled pre-installed content, and importing local files.
class ContentGridScreen extends ConsumerWidget {
  const ContentGridScreen({required this.type, super.key});

  final ContentType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(contentItemsProvider(type));
    final online = ref.watch(isOnlineProvider);
    final downloadedOnly = ref.watch(downloadedOnlyFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_categoryTitles[type]!),
        actions: [
          if (!online)
            IconButton(
              icon: const Icon(Icons.wifi_off_rounded),
              tooltip: 'لا يوجد اتصال بالإنترنت - انقر لإعادة المحاولة',
              onPressed: () => ref.read(contentListProvider.notifier).refresh(),
            ),
          // Filter toggle: Downloaded only / All
          FilterChip(
            selected: downloadedOnly,
            avatar: Icon(
              downloadedOnly ? Icons.cloud_done_rounded : Icons.cloud_outlined,
              size: 16,
              color: downloadedOnly ? Colors.green[800] : null,
            ),
            label: const Text('المُنزَّلة فقط (أوفلاين)'),
            onSelected: (selected) =>
                ref.read(downloadedOnlyFilterProvider.notifier).state = selected,
          ),
          const SizedBox(width: AppSpacing.xs),
          // Import local content button
          IconButton.filledTonal(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: 'استيراد ملف Zip أو مجلد محلي',
            onPressed: () => StorageBrowserDialog.show(context, initialType: type),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorState(
          message: 'تعذّر تحميل المحتوى',
          onRetry: () => ref.invalidate(contentListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('لا يوجد محتوى بعد'));
          }
          return _FilteredContentGrid(items: items, downloadedOnly: downloadedOnly);
        },
      ),
    );
  }
}

class _FilteredContentGrid extends ConsumerWidget {
  const _FilteredContentGrid({required this.items, required this.downloadedOnly});

  final List<ContentItem> items;
  final bool downloadedOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!downloadedOnly) {
      return _ContentGrid(items: items);
    }

    final manager = ref.watch(contentDownloadManagerProvider);

    return FutureBuilder<List<ContentItem>>(
      future: () async {
        final downloadedList = <ContentItem>[];
        for (final item in items) {
          if (await manager.isDownloaded(item)) {
            downloadedList.add(item);
          }
        }
        return downloadedList;
      }(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final downloadedItems = snapshot.data!;
        if (downloadedItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.download_for_offline_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'لم يتم تنزيل أو استيراد أي محتوى بدون إنترنت بعد',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'يمكنك استيراد ملفات Zip أو مجلدات من زر الاستيراد في الأعلى',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  icon: const Icon(Icons.file_upload_outlined),
                  label: const Text('استيراد محتوى محلي الآن'),
                  onPressed: () => StorageBrowserDialog.show(context),
                ),
              ],
            ),
          );
        }
        return _ContentGrid(items: downloadedItems);
      },
    );
  }
}

/// Lays the cards out in a 6-column responsive grid.
class _ContentGrid extends StatelessWidget {
  const _ContentGrid({required this.items});

  final List<ContentItem> items;

  static const _crossAxisCount = 6;
  static const _minCellHeight = 75.0;
  static const _gap = AppSpacing.lg / 2;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rows = (items.length / _crossAxisCount).ceil();
        final cellWidth =
            (constraints.maxWidth - _gap * 2 - _gap * (_crossAxisCount - 1)) / _crossAxisCount;
        final fittedCellHeight = (constraints.maxHeight - _gap * 2 - _gap * (rows - 1)) / rows;
        final fitsWithoutScrolling = fittedCellHeight >= _minCellHeight;
        final cellHeight = fitsWithoutScrolling ? fittedCellHeight : cellWidth / 0.72;

        return GridView.builder(
          padding: const EdgeInsets.all(_gap),
          physics: fitsWithoutScrolling
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _crossAxisCount,
            mainAxisSpacing: _gap,
            crossAxisSpacing: _gap,
            childAspectRatio: cellWidth / cellHeight,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => _ContentCard(item: items[index]),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          FilledButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}

class _ContentCard extends ConsumerStatefulWidget {
  const _ContentCard({required this.item});

  final ContentItem item;

  @override
  ConsumerState<_ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends ConsumerState<_ContentCard> {
  bool _downloaded = false;
  bool _checkedOnce = false;

  @override
  void initState() {
    super.initState();
    _checkDownloaded();
  }

  Future<void> _checkDownloaded() async {
    final downloaded = await ref.read(contentDownloadManagerProvider).isDownloaded(widget.item);
    if (mounted) {
      setState(() {
        _downloaded = downloaded;
        _checkedOnce = true;
      });
    }
  }

  Future<void> _startDownload() async {
    try {
      await ref.read(contentDownloadManagerProvider).download(widget.item);
      await _checkDownloaded();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل التحميل، تأكد من الاتصال بالإنترنت')));
      }
    }
  }

  Future<void> _delete() async {
    if (!await confirmDeleteDownload(context, widget.item.title)) return;
    await ref.read(contentDownloadManagerProvider).delete(widget.item);
    await _checkDownloaded();
  }

  void _open() {
    if (widget.item.contentType == ContentType.book) {
      // The book may have been downloaded from inside the popup.
      BookDetailScreen.show(context, widget.item.folder).then((_) => _checkDownloaded());
      return;
    }
    if (!_downloaded) {
      _startDownload();
      return;
    }
    context.push('/content/player', extra: widget.item);
  }

  Widget _buildCover(ThemeData theme) {
    final cover = widget.item.coverImageUrl;

    if (cover.isNotEmpty && File(cover).existsSync()) {
      return Image.file(File(cover), fit: BoxFit.cover);
    }

    if (cover.startsWith('http://') || cover.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: cover,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: theme.colorScheme.surfaceContainerHighest),
        errorWidget: (context, url, error) => Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            widget.item.contentType == ContentType.book
                ? Icons.auto_stories_rounded
                : Icons.extension_rounded,
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          widget.item.contentType == ContentType.book
              ? Icons.auto_stories_rounded
              : Icons.extension_rounded,
          size: 22,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFavorite = ref.watch(favoritesProvider).contains(widget.item.folder);

    return GestureDetector(
      onTap: _open,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<ContentDownloadProgress>(
              stream: ref.read(contentDownloadManagerProvider).progressStream(widget.item.folder),
              builder: (context, snapshot) {
                final downloading =
                    !_downloaded && snapshot.connectionState == ConnectionState.active;
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildCover(theme),
                            if (downloading) DownloadProgressOverlay(progress: snapshot.data),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: _IconBadge(
                        icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? theme.colorScheme.error : null,
                        onTap: () =>
                            ref.read(favoritesProvider.notifier).toggle(widget.item.folder),
                      ),
                    ),
                    if (_checkedOnce && !downloading)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: _downloaded
                            ? _IconBadge(
                                icon: Icons.check_circle,
                                color: Colors.green,
                                tooltip: 'جاهز بدون إنترنت (أوفلاين) - انقر للحذف',
                                onTap: _delete,
                              )
                            : _IconBadge(
                                icon: Icons.download_rounded,
                                tooltip: 'تنزيل للاستخدام بدون إنترنت',
                                onTap: _startDownload,
                              ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xs / 2),
          Text(
            widget.item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.onTap, this.color, this.tooltip});

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final button = Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(icon, size: 10, color: color ?? theme.colorScheme.onSurface),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
