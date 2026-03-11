import 'package:get/get.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import 'product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRemoteDatasource>(() => ProductRemoteDatasourceImpl());
    Get.lazyPut<ProductLocalDatasource>(() => ProductLocalDatasourceImpl());
    Get.lazyPut(() => ProductRepositoryImpl(
          remoteDatasource: Get.find(),
          localDatasource: Get.find(),
        ));
    Get.lazyPut(() => GetProductsUsecase(Get.find()));
    Get.lazyPut(() => GetProductByIdUsecase(Get.find()));
    Get.lazyPut(() => CreateProductUsecase(Get.find()));
    Get.lazyPut(() => ProductController(
          getProductsUsecase: Get.find(),
          getProductByIdUsecase: Get.find(),
          createProductUsecase: Get.find(),
        ));
  }
}
