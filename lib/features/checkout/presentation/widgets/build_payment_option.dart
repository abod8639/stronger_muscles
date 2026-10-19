import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/checkout/presentation/widgets/payment_option_card.dart';

export 'package:stronger_muscles/features/checkout/presentation/widgets/payment_option_card.dart';

/// Backward-compatible builder that delegates to [PaymentOptionCard].
Widget buildPaymentOption({
  required WidgetRef ref,
  required String value,
  required String title,
  required IconData icon,
  String? subtitle,
  bool enabled = true,
}) {
  return PaymentOptionCard(
    value: value,
    title: title,
    icon: icon,
    subtitle: subtitle,
    enabled: enabled,
  );
}
