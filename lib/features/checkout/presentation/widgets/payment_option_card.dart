import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/checkout/presentation/controllers/checkout_controller.dart';

/// Clean Architecture widget for selecting a payment option in checkout.
class PaymentOptionCard extends ConsumerWidget {
  final String value;
  final String title;
  final IconData icon;
  final String? subtitle;
  final bool enabled;

  const PaymentOptionCard({
    super.key,
    required this.value,
    required this.title,
    required this.icon,
    this.subtitle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutControllerProvider);

    return AppSelectableCard<String>(
      value: value,
      groupValue: checkoutState.selectedPaymentMethod,
      onChanged: enabled
          ? (val) {
              if (val != null) {
                ref.read(checkoutControllerProvider.notifier).setPaymentMethod(val);
              }
            }
          : null,
      title: title,
      subtitle: subtitle,
      leadingIcon: icon,
      enabled: enabled,
    );
  }
}
