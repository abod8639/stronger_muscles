import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'package:stronger_muscles/presentation/bindings/main_controller.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/bindings/wishlist_controller.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';
import 'package:stronger_muscles/presentation/bindings/categories_sections_controller.dart';
import 'package:stronger_muscles/presentation/bindings/search_controller.dart';

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
