import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/auth_service.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:stronger_muscles/core/services/category_service.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/data/repositories/category_repository.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/presentation/controllers/internet_connection_controller.dart';
import 'package:stronger_muscles/presentation/controllers/language_controller.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/presentation/controllers/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Persistent Services~
    Get.put(ApiService(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(AddressService(), permanent: true);

    // Async service initialization
    Get.putAsync(() => WishlistService().init(), permanent: true);
    Get.putAsync(() async => CategoryService() , permanent: true);

   // Repositories 
    Get.put(CategoryRepository(), permanent: true);


    // Global Controllers
    Get.put(InternetConnectionController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(ThemeController(), permanent: true);

    // Controllers
    Get.put(AuthController(), permanent: true);
    Get.put(OrdersController(), permanent: true);
    
  }
}
