import 'package:get/get.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/datasources/order_local_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/get_order_by_id_usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';
import 'order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRemoteDatasource>(() => OrderRemoteDatasourceImpl());
    Get.lazyPut<OrderLocalDatasource>(() => OrderLocalDatasourceImpl());
    Get.lazyPut(() => OrderRepositoryImpl(
          remoteDatasource: Get.find(),
          localDatasource: Get.find(),
        ));
    Get.lazyPut(() => GetOrdersUsecase(Get.find()));
    Get.lazyPut(() => GetOrderByIdUsecase(Get.find()));
    Get.lazyPut(() => CreateOrderUsecase(Get.find()));
    Get.lazyPut(() => OrderController(
          getOrdersUsecase: Get.find(),
          getOrderByIdUsecase: Get.find(),
          createOrderUsecase: Get.find(),
        ));
  }
}
