import 'dart:convert';
import 'package:get/get.dart';
import 'package:stronger_muscles/config/api_config.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import '../../data/models/order_model.dart';

class OrderRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<void> createOrder(OrderModel order) async {
    try {
      final response = await _apiService.post(
        ApiConfig.orders,
        data: order.toJson(),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Failure(message: "فشل في تسجيل الطلب بالسيرفر");
      }

      print("✅ Order placed successfully on server.");
    } catch (e) {
      print("❌ Error in OrderRepository (createOrder): $e");
      rethrow;
    }
  }

  Future<List<OrderModel>> getUserOrders() async {
    try {
      final response = await _apiService.get(ApiConfig.orders);
      final body = jsonDecode(response.body);

      List<dynamic> data = [];

      if (body is Map && body.containsKey('data')) {
        data = body['data'];
      } else if (body is List) {
        data = body;
      }

      // تحويل البيانات باستخدام الـ Model
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      print("❌ Error in OrderRepository (getUserOrders): $e");
      throw Failure(
        message: "فشل في جلب طلباتك، يرجى المحاولة لاحقاً",
        originalError: e,
      );
    }
  }
}
