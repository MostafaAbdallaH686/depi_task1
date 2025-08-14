import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/movies/screens/movies_list_screen.dart';
import '../../features/movies/screens/movie_detail_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const String home = 'home';
  static const String detail = 'detail';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        name: AppRoutes.home,
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MoviesListScreen(),
        ),
        routes: <RouteBase>[
          GoRoute(
            name: AppRoutes.detail,
            path: 'movie/:id',
            pageBuilder: (context, state) {
              final String id = state.pathParameters['id']!;
              return CustomTransitionPage(
                child: MovieDetailScreen(movieId: id),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            },
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text('Route not found: ${state.error}'),
        ),
      ),
    ),
    debugLogDiagnostics: false,
    observers: <NavigatorObserver>[],
  );
}