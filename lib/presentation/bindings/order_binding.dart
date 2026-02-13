import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(() => OrdersController());
  }
}
