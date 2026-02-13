import 'package:get/get.dart';
import 'package:stronger_muscles/functions/app_guard.dart';
import 'package:stronger_muscles/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/routes/routes.dart';

Future<void> handleCheckout() async {
  final controller = Get.find<CartController>();
  if (controller.cartItems.isEmpty) {
    return;
  }
  return AppGuard.runSafe(() async => Get.toNamed(AppRoutes.checkout));
}
