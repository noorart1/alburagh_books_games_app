import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../content/domain/content_type.dart';

/// Categories screen ("المحتويات"): 2x2 grid — Educational Games,
/// Interactive Books, The Holy Quran, Audio Books. Mirrors `MenuFragment`.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      const _CategoryTile(
        type: ContentType.book,
        title: 'القصص التفاعلية',
        icon: Icons.auto_stories_rounded,
      ),
      const _CategoryTile(
        type: ContentType.game,
        title: 'الألعاب التعليمية',
        icon: Icons.extension_rounded,
      ),
      const _CategoryTile(
        type: ContentType.quran,
        title: 'القرآن الكريم',
        icon: Icons.menu_book_rounded,
      ),
      const _CategoryTile(
        type: ContentType.soundBook,
        title: 'الكتب الصوتية',
        icon: Icons.headphones_rounded,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('المحتويات')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        // Always exactly 4 tiles, so size them to the available space (2x2)
        // instead of a fixed square aspect ratio that can push the bottom
        // row off-screen with no visible hint that it's scrollable.
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth = (constraints.maxWidth - AppSpacing.lg) / 2;
            final cellHeight = (constraints.maxHeight - AppSpacing.lg) / 2;
            return GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.lg,
              crossAxisSpacing: AppSpacing.lg,
              childAspectRatio: cellWidth / cellHeight,
              physics: const NeverScrollableScrollPhysics(),
              children: tiles,
            );
          },
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.type, required this.title, required this.icon});

  final ContentType type;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => context.push('/content/${type.name}'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
