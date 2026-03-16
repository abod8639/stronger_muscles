import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/routes/routes.dart';

Future<void> handleCheckout(WidgetRef ref) async {
  final cartState = ref.read(cartControllerProvider);

  if (cartState.value == null || cartState.value!.isEmpty) {
    return;
  }

  if (ref.read(authControllerProvider.notifier).isLoggedIn) {
    return AppGuard.runSafe(
      ref,
      () async => ref.read(routerProvider).push(AppRoutes.checkout),
    );
  } 
  //  (!ref.read(authControllerProvider.notifier).isLoggedIn) {
    // return ref.read(routerProvider).push(AppRoutes.profile);
  // }
}
