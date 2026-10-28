import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/notifications/presentation/pages/notifications_view.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Dedicated modular routing configuration for Notifications feature.
class NotificationsRoutes {
  const NotificationsRoutes._();

  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsView(),
    ),
  ];
}
