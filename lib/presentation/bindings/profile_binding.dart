import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<AddressService>(() => AddressService());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
