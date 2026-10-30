import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';

/// Clean Architecture dumb widget for displaying and selecting from a list of payment methods.
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

  static IconData _resolveIcon(Object? icon) => icon is IconData ? icon : Icons.payments_outlined;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, method) in methods.indexed)
          AppSelectableCard<String>(
            margin: EdgeInsets.only(top: index == 0 ? 0 : AppDimens.spacingSm),
            value: method.id,
            groupValue: selectedMethodId,
            onChanged: method.isEnabled
                ? (id) {
                    if (id != null) onMethodSelected(id);
                  }
                : null,
            title: method.title,
            subtitle: method.subtitle,
            leadingIcon: _resolveIcon(method.icon),
            enabled: method.isEnabled,
          ),
        if (showSecurityBadge) ...[
          const SizedBox(height: AppDimens.spacingLg),
          const AppSecureBadge(),
        ],
      ],
    );
  }
}
