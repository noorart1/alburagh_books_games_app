import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/storage/app_prefs.dart';
import '../../../core/theme/app_theme.dart';

/// Landing screen: logo/illustration, and shortcuts to Menu (Start),
/// Favorites, Settings (parental-gated), Account, and a music toggle.
/// Mirrors `HomeFragment.java` but rebuilt with Material 3 — no attempt to
/// reproduce the original's animated background/rainbow theme.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final musicEnabled = ref.watch(musicEnabledProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    icon: Icon(musicEnabled ? Icons.music_note : Icons.music_off),
                    tooltip: musicEnabled ? 'إيقاف الموسيقى' : 'تشغيل الموسيقى',
                    onPressed: () =>
                        ref.read(musicEnabledProvider.notifier).state = !musicEnabled,
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.person_outline),
                    tooltip: 'الحساب',
                    onPressed: () => context.push(AppRoutes.account),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: 'الإعدادات',
                    onPressed: () => context.push(AppRoutes.parentalGate),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        _Logo(theme: theme),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'البراق',
                          style: theme.textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'محتوى تعليمي وترفيهي للأطفال',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        FilledButton.icon(
                          onPressed: () => context.push(AppRoutes.menu),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('ابدأ'),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.xs,
                          children: [
                            TextButton.icon(
                              onPressed: () => context.push(AppRoutes.favorites),
                              icon: const Icon(Icons.favorite_outline),
                              label: const Text('المفضلة'),
                            ),
                            TextButton.icon(
                              onPressed: () => context.push(AppRoutes.about),
                              icon: const Icon(Icons.info_outline),
                              label: const Text('حول التطبيق'),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.star_outline),
                              label: const Text('قيّم التطبيق'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(48),
      ),
      child: Icon(
        Icons.auto_stories_rounded,
        size: 88,
        color: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}
