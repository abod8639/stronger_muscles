import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/bindings/main_controller.dart';
import 'package:stronger_muscles/presentation/bindings/wishlist_controller.dart';
BindingsBuilder<dynamic> initControllersApp() {
    return BindingsBuilder(() {
      Get.lazyPut<AuthController>(() => AuthController());
      Get.lazyPut<HomeController>(() => HomeController());
      Get.lazyPut<CartController>(() => CartController());
      Get.lazyPut<WishlistController>(() => WishlistController());
      Get.lazyPut<MainController>(() => MainController());
    });
  }