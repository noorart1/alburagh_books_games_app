import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/coming_soon_scaffold.dart';
import '../../features/content/domain/content_item.dart';
import '../../features/content/domain/content_type.dart';
import '../../features/content/presentation/book_detail_screen.dart';
import '../../features/content/presentation/content_grid_screen.dart';
import '../../features/content/presentation/content_player_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/menu/presentation/menu_screen.dart';
import '../../features/parental_gate/presentation/parental_gate_screen.dart';

/// Route paths, named so screens can push/replace without hardcoding strings.
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const menu = '/menu';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const about = '/about';
  static const parentalGate = '/parental-gate';
  static const account = '/account';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.menu,
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: '/content/player',
        builder: (context, state) =>
            ContentPlayerScreen(item: state.extra! as ContentItem),
      ),
      GoRoute(
        path: '/content/book/:folder',
        builder: (context, state) =>
            BookDetailScreen(folder: state.pathParameters['folder']!),
      ),
      GoRoute(
        path: '/content/:type',
        builder: (context, state) {
          final type = ContentType.values.byName(state.pathParameters['type']!);
          return ContentGridScreen(type: type);
        },
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (context, state) => const ComingSoonScaffold(title: 'المفضلة'),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const ComingSoonScaffold(title: 'الإعدادات'),
      ),
      GoRoute(
        path: AppRoutes.about,
        builder: (context, state) => const ComingSoonScaffold(title: 'حول التطبيق'),
      ),
      GoRoute(
        path: AppRoutes.parentalGate,
        builder: (context, state) => const ParentalGateScreen(),
      ),
      GoRoute(
        path: AppRoutes.account,
        builder: (context, state) => const ComingSoonScaffold(title: 'الحساب'),
      ),
    ],
  );
});
