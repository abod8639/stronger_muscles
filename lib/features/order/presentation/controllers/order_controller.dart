import 'package:get/get.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/get_order_by_id_usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';

class OrderController extends GetxController {
  final GetOrdersUsecase getOrdersUsecase;
  final GetOrderByIdUsecase getOrderByIdUsecase;
  final CreateOrderUsecase createOrderUsecase;

  OrderController({
    required this.getOrdersUsecase,
    required this.getOrderByIdUsecase,
    required this.createOrderUsecase,
  });

  final RxList<OrderEntity> items = <OrderEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    items.value = await getOrdersUsecase();
    isLoading.value = false;
  }
}
