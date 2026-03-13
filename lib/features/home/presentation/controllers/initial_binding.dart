import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/auth/data/datasources/auth_service.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_remote_datasource.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/category_controller.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_service.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_service.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/features/product/data/repositories/category_repository.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/internet_connection_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/language_controller.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/theme_controller.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';

class InitialBinding extends Bindings {

  @override
  void dependencies() {
    
    // 1. الأساسيات (Core Services)
    Get.put(ApiService(), permanent: true);
    Get.put(InternetConnectionController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(ThemeController(), permanent: true);

    // Remote
    Get.put(CategoryRemoteDataSource(), permanent: true);
    Get.put(ProductRemoteDataSource(), permanent: true);

    // Local
    Get.put(CategoryLocalDataSource(), permanent: true);
    Get.put(ProductLocalDataSource(), permanent: true);
    
    Get.put(AuthService(), permanent: true);
    Get.put(AddressService(), permanent: true);
    Get.put(WishlistService(), permanent: true);

    Get.put(CategoryRepository(), permanent: true);
    Get.put(ProductRepository(), permanent: true);
    Get.put(AddressRepository(), permanent: true);

    Get.put(AuthController(), permanent: true);
    Get.put(AddressController(), permanent: true);
    Get.put(CategoryController(), permanent: true); 
    Get.put(ProductsController(), permanent: true);
    Get.put(OrdersController(), permanent: true);
    Get.put(WishlistController(), permanent: true);
    Get.put(ProductService(), permanent: true);
  }
}