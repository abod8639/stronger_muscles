import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/order/data/repositories/order_repository.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';

part 'orders_controller.g.dart';

@Riverpod(keepAlive: true)
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepository(ref.watch(apiServiceProvider));
}

@Riverpod(keepAlive: true)
class OrdersController extends _$OrdersController {
  @override
  FutureOr<List<OrderModel>> build() async {
    final isLoggedIn = ref.watch(authControllerProvider.select((state) => state.value != null));
    if (!isLoggedIn) {
      return [];
    }
    // Initial fetch of all user orders to ensure accurate profile stats
    return await _fetchOrders();
  }

  Future<List<OrderModel>> _fetchOrders({int? limit}) async {
    final repository = ref.read(orderRepositoryProvider);
    return await repository.getUserOrders(limit: limit);
  }

  Future<void> fetchAllOrders() async {
    state = const AsyncLoading();
    try {
      final orders = await _fetchOrders();
      state = AsyncData(orders);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refreshOrders() async {
    state = const AsyncLoading();
    try {
      final orders = await _fetchOrders();
      state = AsyncData(orders);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  List<OrderModel> get deliveredOrders => _filterByStatus('delivered');
  List<OrderModel> get pendingOrders => _filterByStatus('pending');
  List<OrderModel> get processingOrders => _filterByStatus('processing');
  List<OrderModel> get cancelledOrders => _filterByStatus('cancelled');

  List<OrderModel> _filterByStatus(String status) {
    return (state.value ?? [])
        .where((o) => o.status.toLowerCase() == status)
        .toList();
  }

  void clearData() {
    state = const AsyncData([]);
  }
}
