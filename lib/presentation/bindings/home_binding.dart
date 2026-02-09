import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/presentation/controllers/wishlist_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductSearchController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CategoriesSectionsController());
    Get.lazyPut(() => WishlistController());
  }
}
