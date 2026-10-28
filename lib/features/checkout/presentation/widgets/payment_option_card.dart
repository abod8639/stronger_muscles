import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/components.dart';
import '../controllers/checkout_controller.dart';

/// Clean Architecture widget for selecting a payment option in checkout.
class PaymentOptionCard extends ConsumerWidget {
  const PaymentOptionCard({
    super.key,
    required this.value,
    required this.title,
    required this.icon,
    this.subtitle,
    this.enabled = true,
  });

  final String value;
  final String title;
  final IconData icon;
  final String? subtitle;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPaymentMethod = ref.watch(
      checkoutControllerProvider.select((s) => s.selectedPaymentMethod),
    );

    return AppSelectableCard<String>(
      value: value,
      groupValue: selectedPaymentMethod,
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
