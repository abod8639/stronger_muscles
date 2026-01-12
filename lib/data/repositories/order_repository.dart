import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stronger_muscles/config/api_config.dart';
import '../../data/models/order_model.dart';

class OrderRepository {
  Future<void> createOrder(OrderModel order) async {
    try {
      final url = Uri.parse(ApiConfig.baseUrl + ApiConfig.orders);
      
      // تحويل الكائن إلى JSON
      final body = jsonEncode(order.toJson());

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN_HERE', // أضفه إذا كنت تستخدم Sanctum أو JWT
        },
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // تم الطلب بنجاح
        print("Success: Order created on server.");
      } else {
        // في حال وجود خطأ من السيرفر (مثل Validation Error)
        print("Server Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
        throw Exception("Failed to create order: ${response.body}");
      }
    } on SocketException {
      throw Exception("No Internet connection");
    } catch (e) {
      print("Unknown Error: $e");
      rethrow;
    }
  }
}