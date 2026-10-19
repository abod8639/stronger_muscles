import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';
import 'package:stronger_muscles/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:stronger_muscles/features/order/data/repositories/order_repository.dart';
import 'package:stronger_muscles/features/payment/data/repositories/payment_repository.dart';

/// Implementation of [CheckoutRepository] orchestrating order creation and payment initiation.
class CheckoutRepositoryImpl implements CheckoutRepository {
  final OrderRepository _orderRepository;
  final PaymentRepository _paymentRepository;

  CheckoutRepositoryImpl({
    required OrderRepository orderRepository,
    required PaymentRepository paymentRepository,
  })  : _orderRepository = orderRepository,
        _paymentRepository = paymentRepository;

  @override
  Future<Map<String, dynamic>> placeOrder(CheckoutParams params) async {
    final payload = params.toPayload();
    final response = await _orderRepository.createOrder(payload);

    if (params.isOnlinePayment) {
      final orderId = response['data']?['id'];
      if (orderId != null) {
        await _paymentRepository.initiatePayment(
          orderId: orderId,
          gateway: params.gateway,
          firstName: params.customerName,
        );
      }
    }

    return response;
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
