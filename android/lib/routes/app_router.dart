import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../presentation/pages/splash_page.dart';
import '../presentation/pages/shell_page.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/meal_plan_page.dart';
import '../presentation/pages/workout_page.dart';
import '../presentation/pages/water_page.dart';
import '../presentation/pages/progress_page.dart';
import '../presentation/pages/settings_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppStrings.splashRoute,
  routes: [
    GoRoute(
      path: AppStrings.splashRoute,
      builder: (context, state) => const SplashPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => ShellPage(child: child),
      routes: [
        GoRoute(
          path: AppStrings.homeRoute,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
        ),
        GoRoute(
          path: AppStrings.mealPlanRoute,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MealPlanPage(),
          ),
        ),
        GoRoute(
          path: AppStrings.workoutRoute,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WorkoutPage(),
          ),
        ),
        GoRoute(
          path: AppStrings.waterRoute,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WaterPage(),
          ),
        ),
        GoRoute(
          path: AppStrings.progressRoute,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProgressPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppStrings.settingsRoute,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
