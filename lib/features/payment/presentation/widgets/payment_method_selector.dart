import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';

/// Clean Architecture widget for presenting and selecting from a list
/// of supported payment methods.
class PaymentMethodSelector extends StatelessWidget {
  final List<PaymentMethodEntity> methods;
  final String selectedMethodId;
  final ValueChanged<String> onMethodSelected;
  final bool showSecurityBadge;

  const PaymentMethodSelector({
    super.key,
    required this.methods,
    required this.selectedMethodId,
    required this.onMethodSelected,
    this.showSecurityBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final method in methods)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AppSelectableCard<String>(
              value: method.id,
              groupValue: selectedMethodId,
              onChanged: method.isEnabled
                  ? (val) {
                      if (val != null) onMethodSelected(val);
                    }
                  : null,
              title: method.title,
              subtitle: method.subtitle,
              leadingIcon: method.icon,
              enabled: method.isEnabled,
            ),
          ),
        if (showSecurityBadge) ...[
          const SizedBox(height: 12.0),
          const AppSecureBadge(),
        ],
      ],
    );
  }
}
