import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stronger_muscles/core/constants/paymob_constants.dart';

class PaymobService {
  final http.Client _client = http.Client();

  Future<String> getAuthToken() async {
    try {
      final response = await _client.post(
        Uri.parse('${PaymobConstants.baseUrl}${PaymobConstants.authEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'api_key': PaymobConstants.apiKey,
        }),
      );
      final data = jsonDecode(response.body);
      return data['token'];
    } catch (e) {
      throw Exception('Failed to get auth token: $e');
    }
  }

  Future<int> getOrderId({
    required String authToken,
    required String amountCents,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${PaymobConstants.baseUrl}${PaymobConstants.orderEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'auth_token': authToken,
          'delivery_needed': 'false',
          'amount_cents': amountCents,
          'currency': 'EGP',
          'items': [],
        }),
      );
      final data = jsonDecode(response.body);
      return data['id'];
    } catch (e) {
      throw Exception('Failed to get order ID: $e');
    }
  }

  Future<String> getPaymentKey({
    required String authToken,
    required String amountCents,
    required int orderId,
    String email = 'NA', 
    String firstName = 'NA', 
    String lastName = 'NA', 
    String phone = 'NA', 
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${PaymobConstants.baseUrl}${PaymobConstants.paymentKeyEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
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
        }),
      );
      final data = jsonDecode(response.body);
      return data['token'];
    } catch (e) {
      throw Exception('Failed to get payment key: $e');
    }
  }
}

