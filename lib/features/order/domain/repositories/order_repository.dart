import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';

/// Domain contract defining order operations.
/// Follows Result/Either pattern via fpdart with typed [Failure] integration.
/// 100% Pure Dart with zero dependencies on Flutter UI or network libraries.
abstract class OrderRepository {
  /// Fetches orders belonging to the authenticated user with optional pagination.
  Future<Either<Failure, List<OrderEntity>>> getUserOrders({
    int page = 1,
    int? limit,
  });

  /// Fetches a specific order by its unique identifier.
  Future<Either<Failure, OrderEntity?>> getOrderById(String id);

  /// Submits and creates a new order from cart/checkout payload.
  Future<Either<Failure, Map<String, dynamic>>> createOrder(
    Map<String, dynamic> payload,
  );

  /// Requests cancellation for a pending or processing order.
  Future<Either<Failure, Unit>> cancelOrder(String id);
}
