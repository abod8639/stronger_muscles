import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'package:stronger_muscles/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/presentation/controllers/product_search_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductService());
    Get.lazyPut(() => ProductSearchController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CategoriesSectionsController());
  }
}
