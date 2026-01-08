import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/bindings/main_controller.dart';
import 'package:stronger_muscles/presentation/bindings/wishlist_controller.dart';
import 'package:stronger_muscles/presentation/bindings/internet_connection_controller.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';
import 'package:stronger_muscles/presentation/bindings/checkout_controller.dart';
import 'package:stronger_muscles/presentation/bindings/language_controller.dart';
import 'package:stronger_muscles/presentation/bindings/theme_controller.dart';
import 'package:stronger_muscles/presentation/bindings/address_controller.dart';

BindingsBuilder<dynamic> initControllersApp() {
  return BindingsBuilder(() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<WishlistController>(() => WishlistController());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<CheckoutController>(() => CheckoutController());
    Get.lazyPut<LanguageController>(() => LanguageController());
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut<AddressController>(() => AddressController());
    Get.put<InternetConnectionController>(InternetConnectionController());
  });
}
