import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/data/repositories/order_repository.dart';
import 'package:stronger_muscles/core/services/storage_service.dart';
import 'base_controller.dart';

class OrdersController extends BaseController {
  final OrderRepository _orderRepository = Get.put(OrderRepository());

  final RxList<OrderModel> orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialOrders();
  }

  Future<void> _loadInitialOrders() async {
    if (orders.isEmpty && StorageService.hasToken) {
      await fetchOrders();
    }
  }

  Future<void> fetchOrders() async {
    if (isLoading.value) return;

    try {
      setLoading(true);
      resetState();

      final fetchedOrders = await _orderRepository.getUserOrders();
      orders.assignAll(fetchedOrders);
    } catch (e) {
      handleError(e, message: _handleErrorMessage(e));
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshOrders() async {
    await fetchOrders();
  }

  List<OrderModel> get deliveredOrders => _filterByStatus('delivered');
  List<OrderModel> get pendingOrders => _filterByStatus('pending');
  List<OrderModel> get processingOrders => _filterByStatus('processing');
  List<OrderModel> get cancelledOrders => _filterByStatus('cancelled');

  List<OrderModel> _filterByStatus(String status) {
    return orders.where((o) => o.status.toLowerCase() == status).toList();
  }

  void clearData() {
    orders.clear();
    resetState();
  }

  String _handleErrorMessage(dynamic e) {
    if (e.toString().contains('network')) {
      return 'تأكد من اتصالك بالإنترنت';
    }
    return 'حدث خطأ أثناء تحميل الطلبات';
  }
}
