import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/routes.dart';
import 'presentation/pages/checkout_view.dart';
import 'presentation/pages/order_success_view.dart';

/// Modular GoRouter route definitions for the Checkout Feature.
class CheckoutRoutes {
  CheckoutRoutes._();

  static const String checkout = AppRoutes.checkout;
  static const String orderSuccess = AppRoutes.orderSuccess;

  static List<RouteBase> get routes => [
        GoRoute(
          path: checkout,
          name: checkout,
          pageBuilder: (context, state) => const MaterialPage(
            child: CheckoutView(),
          ),
        ),
        GoRoute(
          path: orderSuccess,
          name: orderSuccess,
          pageBuilder: (context, state) => const MaterialPage(
            child: OrderSuccessView(),
          ),
        ),
      ];
}
