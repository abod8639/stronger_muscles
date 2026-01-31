import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/data/repositories/order_repository.dart';

class OrdersController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

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

  // Filtered lists
  List<OrderModel> get deliveredOrders =>
      orders.where((o) => o.status.toLowerCase() == 'delivered').toList();

  List<OrderModel> get pendingOrders =>
      orders.where((o) => o.status.toLowerCase() == 'pending').toList();

  List<OrderModel> get processingOrders =>
      orders.where((o) => o.status.toLowerCase() == 'processing').toList();

  List<OrderModel> get cancelledOrders =>
      orders.where((o) => o.status.toLowerCase() == 'cancelled').toList();

  void clearData() {
    orders.clear();
    errorMessage.value = '';
    isLoading.value = false;
  }
}
