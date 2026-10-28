import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/payment/data/models/payment_init_result.dart';
import 'package:stronger_muscles/features/payment/data/models/payment_method_model.dart';

/// Remote data source contract for Payment network operations.
abstract class PaymentRemoteDataSource {
  factory PaymentRemoteDataSource(ApiService apiService) =
      PaymentRemoteDataSourceImpl;

  Future<PaymentInitResult> initiatePayment({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  });

  Future<List<PaymentMethodModel>> getPaymentMethods({
    String lang = 'ar',
  });
}

/// Concrete implementation of [PaymentRemoteDataSource] using [ApiService] and Dio.
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiService _apiService;

  PaymentRemoteDataSourceImpl(this._apiService);

  @override
  Future<PaymentInitResult> initiatePayment({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  }) async {
    try {
      final Map<String, dynamic> body = {'gateway': gateway};
      if (firstName != null && firstName.trim().isNotEmpty) {
        body['first_name'] = firstName.trim();
      }
      if (lastName != null && lastName.trim().isNotEmpty) {
        body['last_name'] = lastName.trim();
      }

      final response = await _apiService.post(
        ApiConfig.payOrder(orderId),
        data: body,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
        return PaymentInitResult.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      }

      throw const ServerFailure(
        message: 'Invalid payment response structure from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutFailure();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const NetworkFailure();
      }
      throw ServerFailure(
        message: e.response?.data?['message']?.toString() ??
            e.message ??
            'فشل في بدء عملية الدفع عبر الخادم',
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    } on Failure {
      rethrow;
    } catch (e, st) {
      throw Failure(
        message: 'فشل في بدء عملية الدفع: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods({
    String lang = 'ar',
  }) async {
    final isAr = lang == 'ar';
    return [
      PaymentMethodModel(
        id: 'cash',
        title: isAr ? 'الدفع عند الاستلام' : 'Cash on Delivery',
        subtitle: isAr
            ? 'ادفع نقدًا عند استلام طلبك لباب منزلك'
            : 'Pay in cash upon doorstep delivery',
        icon: Icons.payments_outlined,
        gateway: 'cash',
        isEnabled: true,
      ),
      PaymentMethodModel(
        id: 'card',
        title: isAr ? 'بطاقة بنكية / بطاقة ائتمان' : 'Credit / Debit Card',
        subtitle: isAr
            ? 'دفع آمن ومشفر عبر Visa أو MasterCard'
            : 'Secure encrypted payment via Visa or MasterCard',
        icon: Icons.credit_card,
        gateway: 'paymob',
        isEnabled: true,
      ),
      PaymentMethodModel(
        id: 'wallet',
        title: isAr ? 'المحافظ الإلكترونية' : 'E-Wallets',
        subtitle: isAr
            ? 'فودافون كاش، أورنج كاش، اتصالات كاش، وي باي'
            : 'Vodafone Cash, Orange, Etisalat, WE Pay',
        icon: Icons.account_balance_wallet_outlined,
        gateway: 'paymob',
        isEnabled: true,
      ),
      PaymentMethodModel(
        id: 'instapay',
        title: isAr ? 'إنستاباي (InstaPay)' : 'InstaPay',
        subtitle: isAr
            ? 'تحويل فوري مباشر ومجاني عبر شبكة المدفوعات اللحظية'
            : 'Instant, free bank transfer via IPN',
        icon: Icons.bolt_outlined,
        gateway: 'instapay',
        isEnabled: true,
      ),
    ];
  }
}
