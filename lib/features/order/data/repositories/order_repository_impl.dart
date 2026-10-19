import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/order/data/datasources/order_local_datasource.dart';
import 'package:stronger_muscles/features/order/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';

/// Concrete implementation of domain [OrderRepository].
/// Handles remote operations with offline cache fallback.
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource _remoteDatasource;
  final OrderLocalDatasource? _localDatasource;

  OrderRepositoryImpl(
    dynamic remoteOrApiService, [
    this._localDatasource,
  ]) : _remoteDatasource = remoteOrApiService is OrderRemoteDatasource
            ? remoteOrApiService
            : OrderRemoteDatasourceImpl(remoteOrApiService as ApiService);

  @override
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    return _remoteDatasource.createOrder(payload);
  }

  @override
  Future<List<OrderEntity>> getUserOrders({int? limit}) async {
    try {
      final remoteOrders = await _remoteDatasource.getUserOrders(limit: limit);
      await _localDatasource?.cacheOrders(remoteOrders);
      return remoteOrders.map((m) => m.toEntity()).toList();
    } on Failure {
      final cached = await _localDatasource?.getCachedOrders();
      if (cached != null && cached.isNotEmpty) {
        final list = limit != null ? cached.take(limit).toList() : cached;
        return list.map((m) => m.toEntity()).toList();
      }
      rethrow;
    } catch (e) {
      final cached = await _localDatasource?.getCachedOrders();
      if (cached != null && cached.isNotEmpty) {
        final list = limit != null ? cached.take(limit).toList() : cached;
        return list.map((m) => m.toEntity()).toList();
      }
      throw Failure(message: "فشل في جلب طلباتك، يرجى المحاولة لاحقاً");
    }
  }

  @override
  Future<OrderEntity?> getOrderById(String id) async {
    try {
      final remoteOrder = await _remoteDatasource.getOrderById(id);
      if (remoteOrder != null) {
        return remoteOrder.toEntity();
      }
      final cached = await _localDatasource?.getCachedOrderById(id);
      return cached?.toEntity();
    } catch (_) {
      final cached = await _localDatasource?.getCachedOrderById(id);
      return cached?.toEntity();
    }
  }
}
