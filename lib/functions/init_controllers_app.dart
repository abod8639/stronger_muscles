import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/auth_service.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
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
import 'package:stronger_muscles/presentation/bindings/orders_controller.dart';

BindingsBuilder<dynamic> initControllersApp() {
  return BindingsBuilder(() {
    // Services
    Get.put(ApiService());
    Get.put(AuthService());
    Get.put(AddressService());

    // Controllers
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
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.put<InternetConnectionController>(InternetConnectionController());
  });
}
