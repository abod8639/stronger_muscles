import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/order/data/datasources/order_local_datasource.dart';
import 'package:stronger_muscles/features/order/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';
import 'package:stronger_muscles/features/order/data/repositories/order_repository_impl.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_item_entity.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';
import 'package:stronger_muscles/features/order/domain/usecases/create_order_usecase.dart';
import 'package:stronger_muscles/features/order/domain/usecases/get_order_by_id_usecase.dart';
import 'package:stronger_muscles/features/order/domain/usecases/get_user_orders_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';

class MockOrderRepository implements OrderRepository {
  List<OrderEntity> orders = [];
  bool shouldThrow = false;

  @override
  Future<List<OrderEntity>> getUserOrders({int? limit}) async {
    if (shouldThrow) throw Exception('Failed to fetch orders');
    if (limit != null) {
      return orders.take(limit).toList();
    }
    return orders;
  }

  @override
  Future<OrderEntity?> getOrderById(String id) async {
    if (shouldThrow) throw Exception('Failed to fetch order');
    return orders.cast<OrderEntity?>().firstWhere(
          (o) => o?.id == id,
          orElse: () => null,
        );
  }

  @override
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    if (shouldThrow) throw Exception('Failed to create order');
    return {
      'status': 'success',
      'order_id': 'order-2',
      'message': 'Order created successfully',
    };
  }
}

class FakeOrderRemoteDatasource implements OrderRemoteDatasource {
  List<OrderModel> remoteOrders = [];
  bool shouldThrow = false;

  @override
  Future<List<OrderModel>> getUserOrders({int? limit}) async {
    if (shouldThrow) throw Failure(message: 'Network error');
    if (limit != null) return remoteOrders.take(limit).toList();
    return remoteOrders;
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    if (shouldThrow) throw Failure(message: 'Network error');
    return remoteOrders.cast<OrderModel?>().firstWhere(
          (o) => o?.id == id,
          orElse: () => null,
        );
  }

  @override
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    if (shouldThrow) throw Failure(message: 'Network error');
    return {'status': 'success', 'order_id': 'created-123'};
  }
}

class FakeOrderLocalDatasource implements OrderLocalDatasource {
  List<OrderModel> cachedOrders = [];

  @override
  Future<List<OrderModel>> getCachedOrders() async => cachedOrders;

  @override
  Future<OrderModel?> getCachedOrderById(String id) async {
    return cachedOrders.cast<OrderModel?>().firstWhere(
          (o) => o?.id == id,
          orElse: () => null,
        );
  }

  @override
  Future<void> cacheOrders(List<OrderModel> models) async {
    cachedOrders = List.from(models);
  }

  @override
  Future<void> clearCache() async {
    cachedOrders.clear();
  }
}

void main() {
  group('Order Clean Architecture Domain & UseCase Tests', () {
    late MockOrderRepository mockRepository;
    late GetUserOrdersUseCase getUserOrdersUseCase;
    late GetOrderByIdUseCase getOrderByIdUseCase;
    late CreateOrderUseCase createOrderUseCase;

    const testOrderItem = OrderItemEntity(
      id: 'item-1',
      orderId: 'order-1',
      productId: 'prod-100',
      productName: 'Whey Protein 1kg',
      unitPrice: 50.0,
      quantity: 2,
      subtotal: 100.0,
      imageUrl: 'https://example.com/whey.png',
      selectedFlavor: 'Chocolate',
    );

    final testOrder = OrderEntity(
      id: 'order-1',
      userId: 'user-1',
      addressId: 'addr-1',
      subtotal: 100.0,
      shippingCost: 10.0,
      discount: 5.0,
      totalAmount: 105.0,
      status: 'pending',
      paymentStatus: 'pending',
      paymentMethod: 'cash',
      items: const [testOrderItem],
      shippingAddress: const AddressEntity(
        id: 1,
        label: 'Home',
        city: 'Cairo',
        street: 'El Tahrir',
      ),
    );

    setUp(() {
      mockRepository = MockOrderRepository();
      mockRepository.orders = [testOrder];
      getUserOrdersUseCase = GetUserOrdersUseCase(mockRepository);
      getOrderByIdUseCase = GetOrderByIdUseCase(mockRepository);
      createOrderUseCase = CreateOrderUseCase(mockRepository);
    });

    test('GetUserOrdersUseCase returns list of OrderEntity', () async {
      final result = await getUserOrdersUseCase();

      expect(result.length, 1);
      expect(result.first.id, 'order-1');
      expect(result.first.items?.first.productName, 'Whey Protein 1kg');
    });

    test('GetOrderByIdUseCase returns order by id or null', () async {
      final order = await getOrderByIdUseCase('order-1');
      expect(order, isNotNull);
      expect(order!.id, 'order-1');

      final nonExistent = await getOrderByIdUseCase('non-existent');
      expect(nonExistent, isNull);
    });

    test('CreateOrderUseCase creates order and returns response map', () async {
      final payload = {
        'user_id': 'user-1',
        'address_id': 'addr-2',
        'subtotal': 200.0,
        'total_amount': 200.0,
      };

      final result = await createOrderUseCase(payload);

      expect(result['status'], 'success');
      expect(result['order_id'], 'order-2');
    });

    test('OrderEntity computed properties work as expected', () {
      expect(testOrder.canBeCancelled, isTrue);
      expect(testOrder.isCompleted, isFalse);
      expect(testOrder.isPaid, isFalse);

      final deliveredPaid = testOrder.copyWith(
        status: 'delivered',
        paymentStatus: 'paid',
      );
      expect(deliveredPaid.canBeCancelled, isFalse);
      expect(deliveredPaid.isCompleted, isTrue);
      expect(deliveredPaid.isPaid, isTrue);

      final cancelled = testOrder.copyWith(status: 'cancelled');
      expect(cancelled.canBeCancelled, isFalse);
    });

    test('OrderEntity equality and copyWith work properly', () {
      final copy = testOrder.copyWith(status: 'processing');
      expect(copy.id, testOrder.id);
      expect(copy.status, 'processing');
      expect(copy == testOrder, isTrue);
    });

    test('OrderItemEntity price getter delegates to unitPrice', () {
      expect(testOrderItem.price, 50.0);
    });

    test('OrderModel toEntity and fromEntity convert properly', () {
      final model = OrderModel(
        id: 'order-model-1',
        userId: 'user-99',
        addressId: 'addr-99',
        subtotal: 120.0,
        shippingCost: 15.0,
        discount: 10.0,
        totalAmount: 125.0,
        status: 'processing',
        paymentStatus: 'paid',
        paymentMethod: 'card',
        trackingNumber: 'TRK123',
        notes: 'Handle with care',
        items: const [
          OrderItemModel(
            id: 'item-m-1',
            orderId: 'order-model-1',
            productId: 'p-1',
            productName: 'BCAA',
            unitPrice: 60.0,
            quantity: 2,
            subtotal: 120.0,
          ),
        ],
      );

      final entity = model.toEntity();
      expect(entity.id, 'order-model-1');
      expect(entity.userId, 'user-99');
      expect(entity.status, 'processing');
      expect(entity.paymentStatus, 'paid');
      expect(entity.trackingNumber, 'TRK123');
      expect(entity.notes, 'Handle with care');
      expect(entity.items?.length, 1);
      expect(entity.items?.first.productName, 'BCAA');

      final reconstructedModel = OrderModel.fromEntity(entity);
      expect(reconstructedModel.id, 'order-model-1');
      expect(reconstructedModel.userId, 'user-99');
      expect(reconstructedModel.status, 'processing');
      expect(reconstructedModel.paymentStatus, 'paid');
      expect(reconstructedModel.trackingNumber, 'TRK123');
      expect(reconstructedModel.items?.first.productName, 'BCAA');
    });

    test('OrderRepositoryImpl fetches from remote and caches locally', () async {
      final remote = FakeOrderRemoteDatasource();
      final local = FakeOrderLocalDatasource();
      final repository = OrderRepositoryImpl(remote, local);

      final model = OrderModel(
        id: 'order-test-1',
        userId: 'user-1',
        addressId: 'addr-1',
        subtotal: 100.0,
        totalAmount: 100.0,
      );
      remote.remoteOrders = [model];

      final result = await repository.getUserOrders();
      expect(result.length, 1);
      expect(result.first.id, 'order-test-1');
      expect(local.cachedOrders.length, 1);
      expect(local.cachedOrders.first.id, 'order-test-1');
    });

    test('OrderRepositoryImpl falls back to local cache when remote fails', () async {
      final remote = FakeOrderRemoteDatasource();
      final local = FakeOrderLocalDatasource();
      final repository = OrderRepositoryImpl(remote, local);

      final cachedModel = OrderModel(
        id: 'order-cached-1',
        userId: 'user-1',
        addressId: 'addr-1',
        subtotal: 80.0,
        totalAmount: 80.0,
      );
      local.cachedOrders = [cachedModel];
      remote.shouldThrow = true;

      final result = await repository.getUserOrders();
      expect(result.length, 1);
      expect(result.first.id, 'order-cached-1');
    });
  });
}
