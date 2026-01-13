import 'package:get/get.dart';
import 'package:stronger_muscles/config/api_config.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../data/models/order_model.dart';

class OrderRepository {
final ApiService _apiService = Get.find<ApiService>();
Future<void> createOrder(OrderModel order) async {
    try {
      // إرسال الطلب باستخدام ApiService المجهز مسبقاً
      await _apiService.post(
        ApiConfig.orders, 
        data: order.toJson(),
      );
      
      print("✅ Order placed successfully on server.");
    } catch (e) {
      // سيتم التقاط أخطاء الـ 401 أو الشبكة هنا من الـ ApiService
      print("❌ Error in OrderRepository: $e");
      rethrow;
    }
  }
}