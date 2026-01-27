import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/auth_service.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/controllers/internet_connection_controller.dart';
import 'package:stronger_muscles/controllers/language_controller.dart';
import 'package:stronger_muscles/controllers/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Persistent Services~
    Get.put(ApiService(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(AddressService(), permanent: true);

    // Async service initialization
    Get.putAsync(() => WishlistService().init(), permanent: true);

    // Global Controllers
    Get.put(InternetConnectionController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
  }
}
