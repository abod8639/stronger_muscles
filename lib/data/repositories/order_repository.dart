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
        data: order.toJson()
      );

      // التأكد من نجاح العملية (Laravel 201 Created)
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Failure(message: "فشل في تسجيل الطلب بالسيرفر");
      }
      
      print("✅ Order placed successfully on server.");
    } catch (e) {
      print("❌ Error in OrderRepository (createOrder): $e");
      rethrow;
    }
  }

  /// جلب طلبات المستخدم مع معالجة الـ Parsing بشكل سليم
  Future<List<OrderModel>> getUserOrders() async {
    try {
      final response = await _apiService.get(ApiConfig.orders);
      final body = jsonDecode(response.body);

      // تصحيح الخطأ: يجب تحويل List<dynamic> إلى List<OrderModel>
      // مع مراعاة تغليف Laravel (API Resources)
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
      // يفضل هنا رمي Failure مخصص ليفهمه الـ Controller
      throw Failure(
        message: "فشل في جلب طلباتك، يرجى المحاولة لاحقاً",
        originalError: e
      );
    }
  }
}