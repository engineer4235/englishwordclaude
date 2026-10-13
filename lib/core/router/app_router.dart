import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../data/providers.dart';
import '../../features/lesson/presentation/unit_screen.dart';
import '../../features/level_map/presentation/level_map_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/placement/presentation/placement_screen.dart';
import '../../features/practice/presentation/practice_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/word_lists/presentation/words_screen.dart';
import 'app_routes.dart';
import 'app_shell.dart';

/// go_router yapılandırması ve alt menü dalları (EWL-20).
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(onboardingStatusProvider, (_, _) => refresh.value++);
  final router = createRouter(
    refreshListenable: refresh,
    redirect: (location) =>
        onboardingRedirect(ref.read(onboardingStatusProvider), location),
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});

/// Tanıtım tamamlanmadıysa tanıtıma, tamamlandıysa ana sayfaya yönlendirir.
String? onboardingRedirect(AsyncValue<bool> status, String location) {
  final done = status.value;
  if (done == null) return null;
  final inFlow =
      location.startsWith(AppRoutes.onboarding) ||
      location.startsWith(AppRoutes.placement);
  if (!done && !inFlow) return AppRoutes.onboarding;
  if (done && location.startsWith(AppRoutes.onboarding)) return AppRoutes.home;
  return null;
}

GoRouter createRouter({
  Listenable? refreshListenable,
  String? Function(String location)? redirect,
}) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refreshListenable,
    redirect: redirect == null
        ? null
        : (context, state) => redirect(state.matchedLocation),
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.placement,
        builder: (context, state) => PlacementScreen(
          fromOnboarding: state.uri.queryParameters['ilk'] == '1',
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(
          navigationShell: navigationShell,
          location: state.uri.path,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'tekrar',
                    builder: (context, state) =>
                        const PracticeScreen(mode: PracticeMode.review),
                  ),
                ],
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
                routes: [
                  GoRoute(
                    path: 'alistirma/favoriler',
                    builder: (context, state) =>
                        const PracticeScreen(mode: PracticeMode.favorites),
                  ),
                  GoRoute(
                    path: 'alistirma/zorlandiklarim',
                    builder: (context, state) =>
                        const PracticeScreen(mode: PracticeMode.difficult),
                  ),
                ],
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
