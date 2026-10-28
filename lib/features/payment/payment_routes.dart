import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/features/payment/presentation/pages/payment_gateway_view.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Dedicated modular routing configuration for Payment feature.
class PaymentRoutes {
  const PaymentRoutes._();

  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.paymentGateway,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is PaymentResultEntity) {
          return PaymentGatewayView(paymentResult: extra);
        } else if (extra is Map<String, dynamic>) {
          final result = extra['paymentResult'] as PaymentResultEntity?;
          if (result != null) {
            return PaymentGatewayView(
              paymentResult: result,
              orderId: extra['orderId']?.toString(),
              amount: (extra['amount'] as num?)?.toDouble(),
            );
          }
        }
        return const Scaffold(
          body: Center(
            child: Text('Invalid payment parameters'),
          ),
        );
      },
    ),
  ];
}
