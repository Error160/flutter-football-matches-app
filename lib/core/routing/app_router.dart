import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/matches/presentation/pages/matches_page.dart';
import '../../features/matches/presentation/bloc/matches_bloc.dart';
import '../di/injection_container.dart' as di;
import 'app_routes.dart';
import 'adaptive_scaffold.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = 
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = 
      GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutes.matches,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BlocProvider<MatchesBloc>(
            create: (context) => di.sl<MatchesBloc>(),
            child: AdaptiveScaffold(
              currentPath: state.fullPath ?? '',
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.matches,
            name: AppRoutes.matchesName,
            builder: (context, state) => const MatchesPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => _buildErrorPage(context),
  );

  static Widget _buildErrorPage(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.r,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8.h),
            Text(
              'The page you\'re looking for doesn\'t exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => goToMatches(),
              child: const Text('Go to Matches'),
            ),
          ],
        ),
      ),
    );
  }

  static void goToMatches() => _router.go(AppRoutes.matches);

  static void goToMatchDetail(String matchId) => 
      _router.go('${AppRoutes.matches}/match/$matchId');

  static void goBack() {
    if (_router.canPop()) {
      _router.pop();
    } else {
      goToMatches();
    }
  }

  static bool canGoBack() => _router.canPop();

  static String get currentLocation {
    final RouteMatch lastMatch = _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch 
        ? lastMatch.matches 
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
} 