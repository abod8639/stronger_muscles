import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
