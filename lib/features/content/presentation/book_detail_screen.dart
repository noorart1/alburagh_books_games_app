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
    _refresh();
  }

  Future<void> _refresh() async {
    final downloaded =
        await ref.read(contentDownloadManagerProvider).isDownloaded(widget.book);
    if (mounted) setState(() => _downloaded = downloaded);
  }

  Future<void> _download() async {
    setState(() => _downloading = true);
    try {
      await ref.read(contentDownloadManagerProvider).download(widget.book);
      await _refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل التحميل، حاول مرة أخرى')),
        );
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _read() {
    context.push('/content/player', extra: widget.book);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = widget.book;
    final isFavorite = ref.watch(favoritesProvider).contains(book.folder);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () => ref.read(favoritesProvider.notifier).toggle(book.folder),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: CachedNetworkImage(
              imageUrl: book.coverImageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(book.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  if (book.author.isNotEmpty) Chip(label: Text('المؤلف: ${book.author}')),
                  if (book.publisher.isNotEmpty) Chip(label: Text('الناشر: ${book.publisher}')),
                  if ((book.illistrator ?? '').isNotEmpty)
                    Chip(label: Text('الرسام: ${book.illistrator}')),
                  Chip(label: Text('الفئة العمرية: ${book.ageGroup}')),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: theme.colorScheme.secondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(book.rate.toStringAsFixed(1)),
                  const SizedBox(width: AppSpacing.md),
                  Icon(Icons.menu_book_outlined, size: 18, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.xs),
                  Text('${book.readings ?? 0} قراءة'),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(book.description, style: theme.textTheme.bodyLarge),
              if (book.samples.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text('عيّنة', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: book.samples.length,
                    separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: book.samples[index],
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: _downloaded
                    ? FilledButton.icon(
                        onPressed: _read,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('قراءة'),
                      )
                    : FilledButton.icon(
                        onPressed: _downloading ? null : _download,
                        icon: _downloading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.download_rounded),
                        label: Text(_downloading ? 'جارٍ التحميل...' : 'تحميل (${book.fileSize})'),
                      ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
