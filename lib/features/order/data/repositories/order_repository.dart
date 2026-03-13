import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';

class OrderRepository {
  final ApiService _apiService;

  OrderRepository(this._apiService);

  Future<void> createOrder(Map<String, dynamic> payload) async {
    try {
      await _apiService.post(ApiConfig.orders, data: payload);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: "حدث خطأ غير متوقع أثناء إرسال الطلب");
    }
  }

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

      return data.map((json) => OrderModel.fromJson(json)).toList();
    } on Failure catch (e) {
      throw Failure(message: e.message);
    } catch (e) {
      throw Failure(message: "فشل في جلب طلباتك، يرجى المحاولة لاحقاً");
    }
  }
}
