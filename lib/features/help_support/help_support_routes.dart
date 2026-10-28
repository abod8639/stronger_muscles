import 'package:go_router/go_router.dart';
import '../../routes/routes.dart';
import 'presentation/pages/help_support_view.dart';

/// Modular routes configuration for Help & Support feature.
class HelpSupportRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.helpSupport,
      builder: (context, state) => const HelpSupportView(),
    ),
  ];
}
