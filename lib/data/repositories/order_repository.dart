import 'dart:convert';
import 'package:get/get.dart';
import 'package:stronger_muscles/config/api_config.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../data/models/order_model.dart';

class OrderRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<void> createOrder(OrderModel order) async {
    try {
      await _apiService.post(
        ApiConfig.orders, 
        data: order.toJson(),
      );
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
      
      // Laravel often wraps data in a 'data' key when using Resources
      final List<dynamic> ordersList = body['data'] ?? [];
      
      return ordersList.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      print("❌ Error in OrderRepository (getUserOrders): $e");
      rethrow;
    }
  }
}