import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'package:stronger_muscles/presentation/controllers/main_controller.dart';
import 'package:stronger_muscles/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/presentation/controllers/wishlist_controller.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/presentation/controllers/search_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());

    // Dependencies for Home Tab
    Get.lazyPut(() => ProductService());
    Get.lazyPut(() => ProductSearchController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CategoriesSectionsController());

    // Dependencies for other tabs
    Get.lazyPut(() => WishlistController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => ProfileController());
  }
}
