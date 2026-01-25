import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
