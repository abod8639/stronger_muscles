import 'package:get/get.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_service.dart';
import 'package:stronger_muscles/features/product/data/repositories/category_repository.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/category_controller.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles/features/promo/presentation/controllers/premo_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductSearchController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CategoriesSectionsController());
    Get.lazyPut(() => WishlistController());
    Get.lazyPut(() => PromoController());
    Get.lazyPut(() => CategoryController());
    Get.lazyPut(() => ProductsController());
    Get.lazyPut(() => CategoryRemoteDataSource());
    Get.lazyPut(() => ProductRemoteDataSource());
    Get.lazyPut(() => CategoryRepository());
    Get.lazyPut(() => ProductRepository());
    Get.lazyPut(() => ProductService());
  }
}
