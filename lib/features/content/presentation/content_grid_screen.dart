import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/content_download_manager.dart';
import '../domain/content_item.dart';
import '../domain/content_type.dart';
import 'content_providers.dart';

const _categoryTitles = {
  ContentType.book: 'القصص التفاعلية',
  ContentType.game: 'الألعاب التعليمية',
  ContentType.quran: 'القرآن الكريم',
  ContentType.soundBook: 'الكتب الصوتية',
};

/// The grid of content cards for one category — mirrors `ContentsFragment`.
/// Books navigate to a detail screen first (`ContentDetailsFragment`);
/// games/quran/sound-books have no details screen and download directly,
/// matching the original app's navigation split.
class ContentGridScreen extends ConsumerWidget {
  const ContentGridScreen({required this.type, super.key});

  final ContentType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(contentItemsProvider(type));

    return Scaffold(
      appBar: AppBar(title: Text(_categoryTitles[type]!)),
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
          return _ContentGrid(items: items);
        },
      ),
    );
  }
}

/// Lays the cards out in a fixed 3-column grid that is scaled to fill the
/// available height with no scrolling when the category has few items
/// (kids shouldn't need to discover a hidden scroll to see everything).
/// Falls back to a normal scrollable grid once there are too many items to
/// keep cards at a legible size.
class _ContentGrid extends StatelessWidget {
  const _ContentGrid({required this.items});

  final List<ContentItem> items;

  static const _crossAxisCount = 3;
  static const _minCellHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rows = (items.length / _crossAxisCount).ceil();
        final cellWidth = (constraints.maxWidth -
                AppSpacing.lg * 2 -
                AppSpacing.lg * (_crossAxisCount - 1)) /
            _crossAxisCount;
        final fittedCellHeight = (constraints.maxHeight -
                AppSpacing.lg * 2 -
                AppSpacing.lg * (rows - 1)) /
            rows;
        final fitsWithoutScrolling = fittedCellHeight >= _minCellHeight;
        final cellHeight = fitsWithoutScrolling ? fittedCellHeight : cellWidth / 0.72;

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          physics: fitsWithoutScrolling
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _crossAxisCount,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.lg,
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
    final downloaded =
        await ref.read(contentDownloadManagerProvider).isDownloaded(widget.item);
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل التحميل، حاول مرة أخرى')),
        );
      }
    }
  }

  Future<void> _delete() async {
    await ref.read(contentDownloadManagerProvider).delete(widget.item);
    await _checkDownloaded();
  }

  void _open() {
    if (widget.item.contentType == ContentType.book) {
      context.push('/content/book/${widget.item.folder}');
      return;
    }
    if (!_downloaded) {
      _startDownload();
      return;
    }
    context.push('/content/player', extra: widget.item);
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
            child: Stack(
              children: [
                Positioned.fill(
                  child: Card(
                    child: CachedNetworkImage(
                      imageUrl: widget.item.coverImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _IconBadge(
                    icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? theme.colorScheme.error : null,
                    onTap: () => ref.read(favoritesProvider.notifier).toggle(widget.item.folder),
                  ),
                ),
                if (_checkedOnce)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _downloaded
                        ? _IconBadge(icon: Icons.check_circle, onTap: _delete)
                        : StreamBuilder<ContentDownloadProgress>(
                            stream: ref
                                .read(contentDownloadManagerProvider)
                                .progressStream(widget.item.folder),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return _IconBadge(
                                  icon: Icons.download_rounded,
                                  onTap: _startDownload,
                                );
                              }
                              final progress = snapshot.data;
                              return SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(value: progress),
                              );
                            },
                          ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.onTap, this.color});

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: color ?? theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}
