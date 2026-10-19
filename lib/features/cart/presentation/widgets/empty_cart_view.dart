import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Displays an empty cart state using unified [AppEmptyState].
class EmptyCartView extends StatelessWidget {
  final VoidCallback onGoShopping;

  const EmptyCartView({super.key, required this.onGoShopping});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppEmptyState(
      icon: Icons.shopping_cart_outlined,
      title: l10n.yourCartIsEmpty,
      subtitle: l10n.addProductsToGetStarted,
      actionText: l10n.startShopping,
      onActionTap: onGoShopping,
    );
  }
}
