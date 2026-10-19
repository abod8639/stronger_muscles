import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';

abstract class OrderRemoteDatasource {
  Future<List<OrderModel>> getUserOrders({int? limit});
  Future<OrderModel?> getOrderById(String id);
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload);
}

class OrderRemoteDatasourceImpl implements OrderRemoteDatasource {
  final ApiService _apiService;

  OrderRemoteDatasourceImpl(this._apiService);

  @override
  Future<List<OrderModel>> getUserOrders({int? limit}) async {
    try {
      final queryParams = limit != null ? {'limit': limit} : null;
      final response = await _apiService.get(
        ApiConfig.orders,
        queryParameters: queryParams,
      );

      final dynamic body = response.data;
      List<dynamic> data = [];

      if (body is Map && body.containsKey('data')) {
        data = body['data'];
      } else if (body is List) {
        data = body;
      }

      return data
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: "فشل في جلب طلباتك، يرجى المحاولة لاحقاً");
    }
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.orders}/$id');
      final dynamic body = response.data;
      final dynamic data = (body is Map && body.containsKey('data'))
          ? body['data']
          : body;

      if (data is Map<String, dynamic>) {
        return OrderModel.fromJson(data);
      }
      return null;
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: "فشل في جلب تفاصيل الطلب");
    }
  }

  @override
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    try {
      final response = await _apiService.post(ApiConfig.orders, data: payload);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {'status': 'success'};
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: "حدث خطأ غير متوقع أثناء إرسال الطلب");
    }
  }
}
