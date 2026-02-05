import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/data/repositories/order_repository.dart';

class OrdersController extends GetxController {
  final OrderRepository _orderRepository = Get.put(OrderRepository());
  // final OrderRepository _orderRepository = Get.find<OrderRepository>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Do not call fetchOrders here if it's already being handled by ProfileController 
    // or if we want to wait for the user to visit the page.
    // However, since it's permanent and used in Profile, we can load it here but with a check.
    _loadInitialOrders();
  }

  Future<void> _loadInitialOrders() async {
    if (orders.isEmpty) {
      await fetchOrders();
    }
  }

  Future<void> fetchOrders() async {
    if (isLoading.value) return; // Prevent concurrent calls
    
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedOrders = await _orderRepository.getUserOrders();
      orders.assignAll(fetchedOrders);
    } catch (e) {
      errorMessage.value = _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await fetchOrders();
  }

  // --- Computed Properties (Getters) ---
  // ملاحظة: GetX سيقوم بتحديث الـ UI تلقائياً عند استخدام هذه الـ Getters داخل Obx
  
  List<OrderModel> get deliveredOrders => _filterByStatus('delivered');
  List<OrderModel> get pendingOrders => _filterByStatus('pending');
  List<OrderModel> get processingOrders => _filterByStatus('processing');
  List<OrderModel> get cancelledOrders => _filterByStatus('cancelled');

  List<OrderModel> _filterByStatus(String status) {
    return orders.where((o) => o.status.toLowerCase() == status).toList();
  }

  void clearData() {
    orders.clear();
    errorMessage.value = '';
    isLoading.value = false;
  }

  String _handleError(dynamic e) {
    print('❌ Error in OrdersController: $e');
    return e.toString().contains('network') 
        ? 'تأكد من اتصالك بالإنترنت' 
        : 'حدث خطأ أثناء تحميل الطلبات';
  }
}