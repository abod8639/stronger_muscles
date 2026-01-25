import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailsController>(() => ProductDetailsController());
  }
}
