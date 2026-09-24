import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/payment/data/models/payment_init_result.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return PaymentRepository(apiService);
});

class PaymentRepository {
  final ApiService _apiService;

  PaymentRepository(this._apiService);

  Future<PaymentInitResult> initiatePayment({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.payOrder(orderId),
        data: {
          'gateway': gateway,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
        return PaymentInitResult.fromJson(data['data'] as Map<String, dynamic>);
      }

      throw Failure(message: 'Invalid payment response from server');
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: 'فشل في بدء عملية الدفع: $e');
    }
  }
}
