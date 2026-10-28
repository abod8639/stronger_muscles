import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/orders_di.dart';

part 'orders_controller.g.dart';

@Riverpod(keepAlive: true)
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return ref.watch(orderRepositoryProvider);
}

@Riverpod(keepAlive: true)
class OrdersController extends _$OrdersController {
  static const int _pageSize = 20;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  bool _isMutating = false;
  bool get isMutating => _isMutating;

  @override
  FutureOr<List<OrderEntity>> build() async {
    _currentPage = 1;
    _isLoadingMore = false;
    _hasMore = true;
    _isMutating = false;

    // Guard: Only fetch orders for authenticated users
    final isLoggedIn = ref.watch(
      authControllerProvider.select((state) => state.valueOrNull != null),
    );
    if (!isLoggedIn) {
      return const [];
    }

    final getUserOrders = ref.watch(getUserOrdersUseCaseProvider);
    final result = await getUserOrders(page: 1, limit: _pageSize);

    return result.fold(
      (failure) {
        if (failure is CancelFailure || failure.type == FailureType.auth) {
          return const [];
        }
        throw failure;
      },
      (orders) {
        _hasMore = orders.length >= _pageSize;
        return orders;
      },
    );
  }

  /// Reloads all user orders with visual loading indicator.
  Future<void> fetchAllOrders() async {
    await refreshOrders();
  }

  /// Background refresh of orders without throwing away previous state abruptly.
  Future<void> refreshOrders() async {
    final isLoggedIn = ref.read(
      authControllerProvider.select((state) => state.valueOrNull != null),
    );
    if (!isLoggedIn) {
      state = const AsyncData([]);
      return;
    }

    _currentPage = 1;
    _isLoadingMore = false;
    _hasMore = true;

    final getUserOrders = ref.read(getUserOrdersUseCaseProvider);
    final result = await getUserOrders(page: 1, limit: _pageSize);

    result.fold(
      (failure) {
        if (failure.type == FailureType.auth || failure is CancelFailure) {
          state = const AsyncData([]);
        } else {
          state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
        }
      },
      (orders) {
        _hasMore = orders.length >= _pageSize;
        state = AsyncData(orders);
      },
    );
  }

  /// Paginated fetch for subsequent order items with guard clauses.
  Future<void> loadMoreOrders() async {
    if (_isLoadingMore || !_hasMore) return;

    final current = state.valueOrNull;
    if (current == null || current.isEmpty) return;

    _isLoadingMore = true;
    final nextPage = _currentPage + 1;

    final getUserOrders = ref.read(getUserOrdersUseCaseProvider);
    final result = await getUserOrders(page: nextPage, limit: _pageSize);

    _isLoadingMore = false;

    result.fold(
      (failure) {
        // Retain existing orders on pagination failure
      },
      (newOrders) {
        if (newOrders.isEmpty || newOrders.length < _pageSize) {
          _hasMore = false;
        }
        if (newOrders.isNotEmpty) {
          _currentPage = nextPage;
          state = AsyncData([...current, ...newOrders]);
        }
      },
    );
  }

  /// Cancels an order with optimistic state update and mutation guard.
  Future<Either<Failure, Unit>> cancelOrder(String id) async {
    if (_isMutating) {
      return left(const ValidationFailure(message: 'Operation in progress'));
    }

    _isMutating = true;
    final cancelUseCase = ref.read(cancelOrderUseCaseProvider);
    final result = await cancelUseCase(id);
    _isMutating = false;

    result.fold(
      (_) {},
      (_) {
        // Optimistically update status to cancelled
        final current = state.valueOrNull;
        if (current != null) {
          state = AsyncData(
            current.map((order) {
              if (order.id == id) {
                return order.copyWith(status: 'cancelled');
              }
              return order;
            }).toList(),
          );
        }
      },
    );

    return result;
  }

  /// Submits and creates an order from checkout payload with mutation guard.
  Future<Either<Failure, Map<String, dynamic>>> submitOrder(
    Map<String, dynamic> payload,
  ) async {
    if (_isMutating) {
      return left(const ValidationFailure(message: 'Order submission in progress'));
    }

    _isMutating = true;
    final createUseCase = ref.read(createOrderUseCaseProvider);
    final result = await createUseCase(payload);
    _isMutating = false;

    result.fold(
      (_) {},
      (_) => refreshOrders(),
    );

    return result;
  }

  List<OrderEntity> get deliveredOrders => _filterByStatus('delivered');
  List<OrderEntity> get pendingOrders => _filterByStatus('pending');
  List<OrderEntity> get processingOrders => _filterByStatus('processing');
  List<OrderEntity> get cancelledOrders => _filterByStatus('cancelled');

  List<OrderEntity> _filterByStatus(String status) {
    return (state.valueOrNull ?? []).where((o) {
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
