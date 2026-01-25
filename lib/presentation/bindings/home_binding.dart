import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/bindings/categories_sections_controller.dart';
import 'package:stronger_muscles/presentation/bindings/search_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductService());
    Get.lazyPut(() => ProductSearchController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CategoriesSectionsController());
  }
}
