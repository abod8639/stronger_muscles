import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_result_entity.dart';
import 'package:stronger_muscles/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:stronger_muscles/features/order/data/repositories/order_repository.dart';
import 'package:stronger_muscles/features/payment/data/repositories/payment_repository.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';

/// Implementation of [CheckoutRepository] orchestrating order creation and payment initiation
/// using centralized error handling, background compute isolation, and timeouts.
class CheckoutRepositoryImpl implements CheckoutRepository {
  final OrderRepository _orderRepository;
  final PaymentRepository _paymentRepository;

  CheckoutRepositoryImpl({
    required OrderRepository orderRepository,
    required PaymentRepository paymentRepository,
  })  : _orderRepository = orderRepository,
        _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, CheckoutResultEntity>> placeOrder(
    CheckoutParams params, {
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute<CheckoutResultEntity>(() async {
      if (cancelToken?.isCancelled ?? false) {
        throw const CancelFailure();
      }

      // Serialize payload asynchronously on a background isolate to prevent UI freezing
      final payload = await params.toPayloadAsync();

      if (cancelToken?.isCancelled ?? false) {
        throw const CancelFailure();
      }

      // Execute order creation with a strict timeout
      final response = await _orderRepository.createOrder(payload).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw const TimeoutFailure(
              message: 'انتهت مهلة إنشاء الطلب. يرجى التحقق من اتصالك والمحاولة مرة أخرى',
            ),
          );

      if (cancelToken?.isCancelled ?? false) {
        throw const CancelFailure();
      }

      PaymentResultEntity? paymentResult;

      if (params.isOnlinePayment) {
        final rawData = response['data'];
        final dynamic rawId = (rawData is Map) ? rawData['id'] : response['id'];
        final orderId = rawId?.toString() ?? '';

        if (orderId.isEmpty) {
          throw const ServerFailure(
            message: 'تم استلام الطلب من الخادم ولكن تعذر الحصول على رقم الطلب لبدء عملية الدفع',
          );
        }

        try {
          paymentResult = await _paymentRepository
              .initiatePayment(
                orderId: orderId,
                gateway: params.gateway,
                firstName: params.customerName,
              )
              .timeout(
                const Duration(seconds: 30),
                onTimeout: () => throw const TimeoutFailure(
                  message: 'انتهت مهلة الاتصال ببوابة الدفع الإلكتروني',
                ),
              );
        } catch (paymentError, paymentStackTrace) {
          // The order has already been registered on the server.
          // Map the error through NetworkErrorHandler and inform user clearly to prevent duplicate orders.
          final failure = NetworkErrorHandler.handle(paymentError, paymentStackTrace);
          throw ServerFailure(
            message: 'تم تأكيد طلبك رقم ($orderId) بنجاح، لكن حدث خطأ أثناء تجهيز الدفع: ${failure.toMessage()}',
            originalError: paymentError,
            stackTrace: paymentStackTrace,
          );
        }
      }

      // Defensive parse using background isolate compute
      return CheckoutResultEntity.fromJsonAsync(
        response,
        paymentResult: paymentResult,
      );
    });
  }
}

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  final paymentRepository = ref.watch(paymentRepositoryProvider);

  return CheckoutRepositoryImpl(
    orderRepository: orderRepository,
    paymentRepository: paymentRepository,
  );
});
