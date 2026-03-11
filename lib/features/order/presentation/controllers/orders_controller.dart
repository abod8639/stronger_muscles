import 'package:get/get.dart';
import 'package:stronger_muscles/features/order/data/repositories/order_repository.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';
import '../../../../presentation/controllers/base_controller.dart';

class OrdersController extends BaseController {
  final OrderRepository _orderRepository = Get.put(OrderRepository());

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  bool _hasFetchedAll = false;

  // Future<void> _loadInitialOrders() async {
  //   // Lazy loading: orders will be fetched when needed (e.g., when Profile or Orders view is opened)
  // }

  Future<void> fetchOrders({int? limit = 3}) async {
    if (isLoading.value) return;

    try {
      setLoading(true);
      // Reset state if we are fetching limited amount initially
      if (limit != null) {
        resetState();
      }

      final fetchedOrders = await _orderRepository.getUserOrders(limit: limit);
      orders.assignAll(fetchedOrders);
      
      if (limit == null) {
        _hasFetchedAll = true;
      } else {
        _hasFetchedAll = fetchedOrders.length < limit;
      }
    } catch (e) {
      handleError(e, message: _handleErrorMessage(e));
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchAllOrders() async {
    if (isLoading.value || _hasFetchedAll) return;

    try {
      setLoading(true);
      
      final fetchedOrders = await _orderRepository.getUserOrders();
      orders.assignAll(fetchedOrders);
      _hasFetchedAll = true;
    } catch (e) {
      handleError(e, message: _handleErrorMessage(e));
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshOrders() async {
    _hasFetchedAll = false;
    await fetchOrders(limit: orders.length > 3 ? null : 3);
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
