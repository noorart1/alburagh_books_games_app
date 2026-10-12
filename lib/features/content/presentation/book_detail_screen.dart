import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/content_download_manager.dart';
import '../data/models/book.dart';
import '../domain/content_type.dart';
import 'content_providers.dart';

/// Book "flip card" detail view — mirrors `ContentDetailsFragment`:
/// cover, title/author/publisher/illustrator/age group, description, rating
/// (read-only display, matching `readings`/`rate` from the API), sample
/// images, and a primary Download/Read action.
class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({required this.folder, super.key});

  final String folder;

  /// Shows the details as a popup over the current screen.
  static Future<void> show(BuildContext context, String folder) {
    final size = MediaQuery.sizeOf(context);
    return showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          width: size.width * 0.8,
          height: size.height * 0.85,
          // Own messenger so snackbars show inside the popup, not behind it.
          child: ScaffoldMessenger(child: BookDetailScreen(folder: folder)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(contentItemsProvider(ContentType.book));

    return Scaffold(
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text('تعذّر تحميل التفاصيل')),
        data: (items) {
          final book = items.whereType<Book>().where((b) => b.folder == folder).firstOrNull;
          if (book == null) {
            return const Center(child: Text('لم يتم العثور على الكتاب'));
          }
          return _BookDetailBody(book: book);
        },
      ),
    );
  }
}

class _BookDetailBody extends ConsumerStatefulWidget {
  const _BookDetailBody({required this.book});

  final Book book;

  @override
  ConsumerState<_BookDetailBody> createState() => _BookDetailBodyState();
}

class _BookDetailBodyState extends ConsumerState<_BookDetailBody> {
  bool _downloaded = false;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    // Popup reopened mid-download: show it as downloading and join it.
    if (ref.read(contentDownloadManagerProvider).isDownloading(widget.book)) {
      _download();
    } else {
      _refresh();
    }
  }

  Future<void> _refresh() async {
    final downloaded = await ref.read(contentDownloadManagerProvider).isDownloaded(widget.book);
    if (mounted) setState(() => _downloaded = downloaded);
  }

  Future<void> _download() async {
    setState(() => _downloading = true);
    try {
      await ref.read(contentDownloadManagerProvider).download(widget.book);
      await _refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل التحميل، تأكد من الاتصال بالإنترنت')));
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _read() {
    context.push('/content/player', extra: widget.book);
  }

  Future<void> _delete() async {
    if (!await confirmDeleteDownload(context, widget.book.title)) return;
    await ref.read(contentDownloadManagerProvider).delete(widget.book);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = widget.book;
    final isFavorite = ref.watch(favoritesProvider).contains(book.folder);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 0.72,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildCover(theme, book.coverImageUrl),
              StreamBuilder<ContentDownloadProgress>(
                stream: ref.read(contentDownloadManagerProvider).progressStream(book.folder),
                builder: (context, snapshot) => snapshot.connectionState == ConnectionState.active
                    ? DownloadProgressOverlay(progress: snapshot.data)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                      color: isFavorite ? theme.colorScheme.error : null,
                      onPressed: () => ref.read(favoritesProvider.notifier).toggle(book.folder),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            if (book.author.isNotEmpty) Chip(label: Text('المؤلف: ${book.author}')),
                            if (book.publisher.isNotEmpty)
                              Chip(label: Text('الناشر: ${book.publisher}')),
                            if ((book.illistrator ?? '').isNotEmpty)
                              Chip(label: Text('الرسام: ${book.illistrator}')),
                            Chip(label: Text('الفئة العمرية: ${book.ageGroup}')),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(Icons.star_rounded, color: theme.colorScheme.secondary),
                            const SizedBox(width: AppSpacing.xs),
                            Text(book.rate.toStringAsFixed(1)),
                            const SizedBox(width: AppSpacing.md),
                            Icon(
                              Icons.menu_book_outlined,
                              size: 18,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text('${book.readings ?? 0} قراءة'),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(book.description, style: theme.textTheme.bodyMedium),
                        if (book.samples.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          SizedBox(
                            height: 90,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: book.samples.length,
                              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                              itemBuilder: (context, index) => ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: book.samples[index],
                                  width: 65,
                                  fit: BoxFit.cover,
                                  placeholder: (_, _) =>
                                      Container(color: theme.colorScheme.surfaceContainerHighest),
                                  errorWidget: (_, _, _) => Container(
                                    width: 65,
                                    color: theme.colorScheme.surfaceContainerHighest,
                                    child: const Icon(Icons.image_not_supported_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _downloaded
                    ? Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _read,
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('قراءة'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          IconButton.outlined(
                            onPressed: _delete,
                            tooltip: 'حذف التحميل',
                            color: theme.colorScheme.error,
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                        ],
                      )
                    : FilledButton.icon(
                        onPressed: _downloading ? null : _download,
                        icon: const Icon(Icons.download_rounded),
                        label: Text(_downloading ? 'جارٍ التحميل...' : 'تحميل (${book.fileSize})'),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCover(ThemeData theme, String cover) {
    if (cover.isNotEmpty && File(cover).existsSync()) {
      return Image.file(File(cover), fit: BoxFit.cover);
    }
    if (cover.startsWith('http://') || cover.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: cover,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(color: theme.colorScheme.surfaceContainerHighest),
        errorWidget: (_, _, _) => Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.auto_stories_rounded, size: 64),
        ),
      );
    }
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.auto_stories_rounded, size: 64),
    );
  }
}

/// Asks before removing a downloaded item's files from the device.
Future<bool> confirmDeleteDownload(BuildContext context, String title) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('حذف التحميل؟'),
      content: Text('سيتم حذف «$title» من الجهاز، ويمكنك تنزيله مرة أخرى لاحقاً.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('حذف'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Dims the whole cover and shows a large progress ring with a percentage.
/// [progress] is null while the zip is being extracted (indeterminate ring).
class DownloadProgressOverlay extends StatelessWidget {
  const DownloadProgressOverlay({required this.progress, super.key});

  final double? progress;

  @override
  Widget build(BuildContext context) {
    final progress = this.progress;
    return ColoredBox(
      color: Colors.black54,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.6,
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  color: Colors.white,
                  backgroundColor: Colors.white24,
                ),
                if (progress != null)
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
