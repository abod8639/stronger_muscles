import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/presentation/controllers/address_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(() => CheckoutController());
    Get.lazyPut<AddressController>(() => AddressController());
  }
}
