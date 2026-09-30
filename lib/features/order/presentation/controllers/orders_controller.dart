import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/order/data/repositories/order_repository.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/usecases/usecase_providers.dart';

part 'orders_controller.g.dart';

@Riverpod(keepAlive: true)
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepositoryImpl(ref.watch(apiServiceProvider));
}

@Riverpod(keepAlive: true)
class OrdersController extends _$OrdersController {
  @override
  FutureOr<List<OrderEntity>> build() async {
    final isLoggedIn =
        ref.watch(authControllerProvider.select((state) => state.value != null));
    if (!isLoggedIn) {
      return [];
    }
    // Initial fetch of all user orders to ensure accurate profile stats
    return await _fetchOrders();
  }

  Future<List<OrderEntity>> _fetchOrders({int? limit}) async {
    final useCase = ref.read(getUserOrdersUseCaseProvider);
    return await useCase(limit: limit);
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

  List<OrderEntity> get deliveredOrders => _filterByStatus('delivered');
  List<OrderEntity> get pendingOrders => _filterByStatus('pending');
  List<OrderEntity> get processingOrders => _filterByStatus('processing');
  List<OrderEntity> get cancelledOrders => _filterByStatus('cancelled');

  List<OrderEntity> _filterByStatus(String status) {
    return (state.value ?? []).where((o) {
      final s = o.status.toLowerCase();
      if (status == 'cancelled') {
        return s == 'cancelled' || s == 'canceled';
      }
      return s == status;
    }).toList();
  }

  void clearData() {
    state = const AsyncData([]);
  }
}
