import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Handles navigation to checkout or login screen based on auth and cart state.
Future<void> handleCheckout(WidgetRef ref) async {
  final cartItems = ref.read(cartControllerProvider).valueOrNull ?? [];

  if (cartItems.isEmpty) {
    return;
  }

  final isLoggedIn = ref.read(authControllerProvider).valueOrNull != null;

  if (isLoggedIn) {
    return AppGuard.runSafe(
      ref,
      () async => ref.read(routerProvider).push(AppRoutes.checkout),
    );
  } else {
    return AppGuard.runSafe(
      ref,
      () async => ref.read(routerProvider).push(AppRoutes.signIn),
    );
  }
}
