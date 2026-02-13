import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrdersController());
  }
}
