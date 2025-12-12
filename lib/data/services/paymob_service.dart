import 'package:dio/dio.dart';
import 'package:stronger_muscles/core/constants/paymob_constants.dart';

class PaymobService {
  final Dio _dio = Dio();

  Future<String> getAuthToken() async {
    try {
      final response = await _dio.post(
        '${PaymobConstants.baseUrl}${PaymobConstants.authEndpoint}',
        data: {
          'api_key': PaymobConstants.apiKey,
        },
      );
      return response.data['token'];
    } catch (e) {
      throw Exception('Failed to get auth token: $e');
    }
  }

  Future<int> getOrderId({
    required String authToken,
    required String amountCents,
  }) async {
    try {
      final response = await _dio.post(
        '${PaymobConstants.baseUrl}${PaymobConstants.orderEndpoint}',
        data: {
          'auth_token': authToken,
          'delivery_needed': 'false',
          'amount_cents': amountCents,
          'currency': 'EGP',
          'items': [], // Paymob requires items array, can be empty for simple amount charge
        },
      );
      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to get order ID: $e');
    }
  }

  Future<String> getPaymentKey({
    required String authToken,
    required String amountCents,
    required int orderId,
    // Add billing data arguments as needed, using basic placeholders for now
    String email = 'NA', 
    String firstName = 'NA', 
    String lastName = 'NA', 
    String phone = 'NA', 
  }) async {
    try {
      final response = await _dio.post(
        '${PaymobConstants.baseUrl}${PaymobConstants.paymentKeyEndpoint}',
        data: {
          'auth_token': authToken,
          'amount_cents': amountCents,
          'expiration': 3600,
          'order_id': orderId,
          'billing_data': {
            'apartment': 'NA',
            'email': email,
            'floor': 'NA',
            'first_name': firstName,
            'street': 'NA',
            'building': 'NA',
            'phone_number': phone,
            'shipping_method': 'NA',
            'postal_code': 'NA',
            'city': 'NA',
            'country': 'NA',
            'last_name': lastName,
            'state': 'NA',
          },
          'currency': 'EGP',
          'integration_id': PaymobConstants.integrationId,
        },
      );
      return response.data['token'];
    } catch (e) {
      throw Exception('Failed to get payment key: $e');
    }
  }
}
