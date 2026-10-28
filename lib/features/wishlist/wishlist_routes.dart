import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/wishlist/presentation/pages/wishlist_view.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Modular GoRouter route definitions for the Wishlist feature.
class WishlistRoutes {
  static const String wishlistPath = AppRoutes.wishlist;

  /// Dedicated [StatefulShellBranch] for shell bottom navigation.
  static StatefulShellBranch get branch => StatefulShellBranch(
        routes: [
          GoRoute(
            path: wishlistPath,
            builder: (context, state) => const WishlistView(),
          ),
        ],
      );

  /// Standalone [GoRoute] if accessed outside the shell.
  static GoRoute get route => GoRoute(
        path: wishlistPath,
        builder: (context, state) => const WishlistView(),
      );

  /// Route base collection for modular router registration.
  static List<RouteBase> get routes => [route];
}
