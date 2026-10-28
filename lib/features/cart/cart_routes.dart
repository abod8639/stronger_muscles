import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/cart/presentation/pages/cart_view.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Modular GoRouter route definitions for the Cart feature.
class CartRoutes {
  static const String cartPath = AppRoutes.cart;

  /// Dedicated StatefulShellBranch for nested bottom navigation tabs.
  static StatefulShellBranch get branch => StatefulShellBranch(
        routes: [
          GoRoute(
            path: cartPath,
            builder: (context, state) => const CartView(),
          ),
        ],
      );

  /// Standalone GoRoute if used outside a shell branch.
  static GoRoute get route => GoRoute(
        path: cartPath,
        builder: (context, state) => const CartView(),
      );
}
