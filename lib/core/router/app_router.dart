import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/lesson/presentation/unit_screen.dart';
import '../../features/level_map/presentation/level_map_screen.dart';
import '../../features/practice/presentation/practice_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/word_lists/presentation/words_screen.dart';
import 'app_routes.dart';
import 'app_shell.dart';

/// go_router yapılandırması ve alt menü dalları (EWL-20).
final routerProvider = Provider<GoRouter>((ref) {
  final router = createRouter();
  ref.onDispose(router.dispose);
  return router;
});

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.levelMap,
                builder: (context, state) => const LevelMapScreen(),
                routes: [
                  GoRoute(
                    path: 'unite/:unitId',
                    builder: (context, state) => UnitScreen(
                      unitId: int.parse(state.pathParameters['unitId']!),
                    ),
                    routes: [
                      GoRoute(
                        path: 'alistirma',
                        builder: (context, state) => PracticeScreen(
                          mode: PracticeMode.lesson,
                          unitId: int.parse(state.pathParameters['unitId']!),
                        ),
                      ),
                      GoRoute(
                        path: 'sinav',
                        builder: (context, state) => PracticeScreen(
                          mode: PracticeMode.unitExam,
                          unitId: int.parse(state.pathParameters['unitId']!),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'seviye/:levelId/sinav',
                    builder: (context, state) => PracticeScreen(
                      mode: PracticeMode.levelExam,
                      levelId: int.parse(state.pathParameters['levelId']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.words,
                builder: (context, state) => const WordsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.stats,
                builder: (context, state) => const StatsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
