import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/order/data/datasources/order_local_datasource.dart';
import 'package:stronger_muscles/features/order/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles/features/order/data/mappers/order_mapper.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';

/// Concrete implementation of domain [OrderRepository].
/// Acts as Single Source of Truth orchestrating [OrderRemoteDatasource]
/// and [OrderLocalDatasource] with offline caching and functional error handling.
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource _remoteDatasource;
  final OrderLocalDatasource _localDatasource;

  OrderRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
  );

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders({
    int page = 1,
    int? limit,
  }) async {
    return NetworkErrorHandler.execute<List<OrderEntity>>(() async {
      try {
        final remoteOrders = await _remoteDatasource.getUserOrders(
          page: page,
          limit: limit,
        );

        if (page == 1) {
          unawaited(_localDatasource.cacheOrders(remoteOrders));
        }

        return remoteOrders.map((m) => m.toEntity()).toList();
      } on Failure catch (failure) {
        if (failure is CancelFailure) rethrow;

        // Fallback to local cache on network or server errors
        final cached = await _localDatasource.getCachedOrders();
        if (cached.isNotEmpty) {
          final list = limit != null ? cached.take(limit).toList() : cached;
          return list.map((m) => m.toEntity()).toList();
        }
        rethrow;
      }
    });
  }

  @override
  Future<Either<Failure, OrderEntity?>> getOrderById(String id) async {
    return NetworkErrorHandler.execute<OrderEntity?>(() async {
      try {
        final remoteOrder = await _remoteDatasource.getOrderById(id);
        if (remoteOrder != null) {
          unawaited(_localDatasource.updateCachedOrder(remoteOrder));
          return remoteOrder.toEntity();
        }

        final cached = await _localDatasource.getCachedOrderById(id);
        return cached?.toEntity();
      } on Failure catch (failure) {
        if (failure is CancelFailure) rethrow;

        final cached = await _localDatasource.getCachedOrderById(id);
        if (cached != null) {
          return cached.toEntity();
        }
        rethrow;
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createOrder(
    Map<String, dynamic> payload,
  ) async {
    return NetworkErrorHandler.execute<Map<String, dynamic>>(() async {
      final response = await _remoteDatasource.createOrder(payload);
      return response;
    });
  }

  @override
  Future<Either<Failure, Unit>> cancelOrder(String id) async {
    return NetworkErrorHandler.execute<Unit>(() async {
      await _remoteDatasource.cancelOrder(id);

      final cached = await _localDatasource.getCachedOrderById(id);
      if (cached != null) {
        final updated = cached.copyWith(status: 'cancelled');
        unawaited(_localDatasource.updateCachedOrder(updated));
      }

      return unit;
    });
  }
}
