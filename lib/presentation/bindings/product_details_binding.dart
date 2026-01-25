import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;

    if (args is ProductModel) {
      Get.lazyPut<ProductDetailsController>(
        () => ProductDetailsController(args),
      );
    } else if (args is Map<String, dynamic>) {
      final product = args['product'] as ProductModel;
      final flavor = args['selectedFlavor'] as String?;
      final size = args['selectedSize'] as String?;

      Get.lazyPut<ProductDetailsController>(
        () => ProductDetailsController(
          product,
          initialFlavor: flavor,
          initialSize: size,
        ),
      );
    } else {
      // Fallback or throw error if opened without product
      // throw Exception('ProductDetailsView requires a ProductModel in arguments');
    }
  }
}
