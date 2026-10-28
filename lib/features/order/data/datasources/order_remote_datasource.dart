import 'package:dio/dio.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';

abstract class OrderRemoteDatasource {
  Future<List<OrderModel>> getUserOrders({
    int page = 1,
    int? limit,
    CancelToken? cancelToken,
  });

  Future<OrderModel?> getOrderById(
    String id, {
    CancelToken? cancelToken,
  });

  Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> payload, {
    CancelToken? cancelToken,
  });

  Future<void> cancelOrder(
    String id, {
    CancelToken? cancelToken,
  });
}

class OrderRemoteDatasourceImpl implements OrderRemoteDatasource {
  final ApiService _apiService;
  static const Duration _timeout = Duration(seconds: 15);

  OrderRemoteDatasourceImpl(this._apiService);

  @override
  Future<List<OrderModel>> getUserOrders({
    int page = 1,
    int? limit,
    CancelToken? cancelToken,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        // ignore: use_null_aware_elements
        if (limit != null) 'limit': limit,
      };

      final response = await _apiService.get(
        ApiConfig.orders,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        timeout: _timeout,
      );

      final dynamic body = response.data;
      List<dynamic> items = const [];

      if (body is Map && body.containsKey('data')) {
        final d = body['data'];
        if (d is List) items = d;
      } else if (body is List) {
        items = body;
      }

      final results = <OrderModel>[];
      for (final item in items) {
        if (item is Map) {
          try {
            results.add(OrderModel.fromJson(Map<String, dynamic>.from(item)));
          } catch (_) {
            // Drop corrupted individual items safely
          }
        }
      }
      return results;
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      if (e is Failure) rethrow;
      throw NetworkErrorHandler.handle(e, st);
    }
  }

  @override
  Future<OrderModel?> getOrderById(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.orders}/$id',
        cancelToken: cancelToken,
        timeout: _timeout,
      );

      final dynamic body = response.data;
      final dynamic data = (body is Map && body.containsKey('data'))
          ? body['data']
          : body;

      if (data is Map) {
        return OrderModel.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      if (e is Failure) rethrow;
      throw NetworkErrorHandler.handle(e, st);
    }
  }

  @override
  Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> payload, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.orders,
        data: payload,
        cancelToken: cancelToken,
        timeout: _timeout,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return {'status': 'success'};
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      if (e is Failure) rethrow;
      throw NetworkErrorHandler.handle(e, st);
    }
  }

  @override
  Future<void> cancelOrder(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      await _apiService.post(
        '${ApiConfig.orders}/$id/cancel',
        cancelToken: cancelToken,
        timeout: _timeout,
      );
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      if (e is Failure) rethrow;
      throw NetworkErrorHandler.handle(e, st);
    }
  }
}
