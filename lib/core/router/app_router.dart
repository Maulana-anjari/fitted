import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/daily_fit/daily_fit_screen.dart';
import '../../features/wardrobe/presentation/screens/wardrobe_screen.dart';
import '../../features/wardrobe/presentation/screens/wardrobe_item_detail.dart';
import '../../features/wardrobe/presentation/screens/wardrobe_upload_screen.dart';
import '../../features/planner/presentation/screens/fit_planner_screen.dart';
import '../../features/fit_check/presentation/screens/fit_check_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../shared/widgets/app_scaffold.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.dailyFit,
    redirect: (context, state) {
      final isAuthenticated = authState.value?.isAuthenticated ?? false;
      final isAuthRoute = state.matchedLocation == RouteNames.welcome ||
          state.matchedLocation == RouteNames.onboarding ||
          state.matchedLocation == RouteNames.login ||
          state.matchedLocation == RouteNames.signup;

      if (!isAuthenticated && !isAuthRoute) {
        return RouteNames.welcome;
      }
      if (isAuthenticated && isAuthRoute) {
        return RouteNames.dailyFit;
      }
      return null;
    },
    routes: [
      // Auth routes (no bottom nav)
      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        builder: (_, __) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signup,
        name: 'signup',
        builder: (_, __) => const SignupScreen(),
      ),

      // Main app shell with bottom nav
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) =>
            AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.dailyFit,
                name: 'dailyFit',
                builder: (_, __) => const DailyFitScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.wardrobe,
                name: 'wardrobe',
                builder: (_, __) => const WardrobeScreen(),
              ),
              GoRoute(
                path: '${RouteNames.wardrobe}/item/:itemId',
                name: 'wardrobeItemDetail',
                builder: (_, state) => WardrobeItemDetail(
                  itemId: state.pathParameters['itemId']!,
                ),
              ),
              GoRoute(
                path: '${RouteNames.wardrobe}/upload',
                name: 'wardrobeUpload',
                builder: (_, __) => const WardrobeUploadScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.fitPlanner,
                name: 'fitPlanner',
                builder: (_, __) => const FitPlannerScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.fitCheck,
                name: 'fitCheck',
                builder: (_, __) => const FitCheckScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                name: 'profile',
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
