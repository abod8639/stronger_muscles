import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/data/repositories/order_repository.dart';

class OrdersController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  
  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final fetchedOrders = await _orderRepository.getUserOrders();
      orders.assignAll(fetchedOrders);
      
      print('✅ Fetched ${orders.length} orders');
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error fetching orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await fetchOrders();
  }
}
