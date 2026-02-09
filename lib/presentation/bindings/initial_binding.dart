import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/auth_service.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:stronger_muscles/core/services/category_service.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/data/repositories/category_repository.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart';
import 'package:stronger_muscles/data/repositories/address_repository.dart';
import 'package:stronger_muscles/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/presentation/controllers/internet_connection_controller.dart';
import 'package:stronger_muscles/presentation/controllers/language_controller.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/presentation/controllers/theme_controller.dart';
import 'package:stronger_muscles/presentation/controllers/wishlist_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Persistent Services~
    Get.put(ApiService(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(AddressService(), permanent: true);
    Get.put(ProductService(), permanent: true);

    // Services
    Get.put(WishlistService(), permanent: true);
    Get.put(CategoryService(), permanent: true);

    // Repositories
    Get.put(CategoryRepository(), permanent: true);
    Get.put(ProductRepository(), permanent: true);
    Get.put(AddressRepository(), permanent: true);
    Get.put(AddressController(), permanent: true);

    // Global Controllers
    Get.put(InternetConnectionController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(ThemeController(), permanent: true);

    // Controllers
    Get.put(AuthController(), permanent: true);
    Get.put(OrdersController(), permanent: true);
    Get.put(WishlistController(), permanent: true);
  }
}
