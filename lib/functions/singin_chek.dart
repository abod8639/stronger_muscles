import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';

class SigninChek {

  static void runIfConnected(
    Future<void> Function() action, {
    String message = "يرجى التحقق من اتصالك بالإنترنت للمتابعة",
  }) async {
    final controller = Get.find<AuthController>();

    if (controller.isLoggedIn.value) {
      await action();
    } else {
      Get.toNamed('/login');
    }
  }

  
}