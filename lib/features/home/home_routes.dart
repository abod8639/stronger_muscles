import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/home/presentation/pages/home_view.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Dedicated routing configuration for Home feature.
class HomeRoutes {
  const HomeRoutes._();

  /// Primary shell branch integrated into app indexed navigation.
  static StatefulShellBranch get branch => StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.main,
            builder: (context, state) => const HomeView(),
          ),
        ],
      );

  /// Standalone routes and redirects for Home.
  static final List<RouteBase> standaloneRoutes = [
    GoRoute(
      path: AppRoutes.home,
      redirect: (context, state) => AppRoutes.main,
    ),
  ];
}
