import 'package:get/get.dart';
import 'package:stronger_muscles/config/api_config.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import '../../data/models/order_model.dart';

class OrderRepository {
  // يفضل استخدام Get.find إذا كان قد تم حقنه في الـ Bindings
  final ApiService _apiService = Get.find<ApiService>();

  Future<void> createOrder(Map<String, dynamic> payload) async {
    try {
      // Dio سيرمي Exception تلقائياً إذا كان الـ Status Code ليس 2xx
      // بناءً على إعدادات الـ ApiService التي صممناها
      await _apiService.post(ApiConfig.orders, data: payload);

      print("✅ Order placed successfully on server.");
    } on Failure catch (e) {
      print("❌ API Failure in createOrder: ${e.message}");
      rethrow;
    } catch (e) {
      print("❌ Unexpected Error in createOrder: $e");
      throw Failure(message: "حدث خطأ غير متوقع أثناء إرسال الطلب");
    }
  }

  Future<List<OrderModel>> getUserOrders() async {
    try {
      final response = await _apiService.get(ApiConfig.orders);

      // البيانات تأتي معالجة كـ Map أو List تلقائياً عبر Dio
      final dynamic body = response.data;
      List<dynamic> data = [];

      if (body is Map && body.containsKey('data')) {
        data = body['data'];
      } else if (body is List) {
        data = body;
      }

      return data.map((json) => OrderModel.fromJson(json)).toList();
    } on Failure catch (e) {
      // إعادة رمي الفشل القادم من السيرفر مع رسالة مخصصة إذا أردت
      throw Failure(message: e.message);
    } catch (e) {
      print("❌ Error in OrderRepository (getUserOrders): $e");
      throw Failure(message: "فشل في جلب طلباتك، يرجى المحاولة لاحقاً");
    }
  }
}
