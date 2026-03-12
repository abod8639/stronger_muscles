import 'package:get/get.dart';
import 'package:stronger_muscles/features/promo/presentation/controllers/premo_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/main_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());

    // Dependencies for Home Tab
    Get.lazyPut(() => ProductSearchController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CategoriesSectionsController());

    // Dependencies for other tabs
    Get.lazyPut(() => WishlistController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => PromoController());
  }
}
