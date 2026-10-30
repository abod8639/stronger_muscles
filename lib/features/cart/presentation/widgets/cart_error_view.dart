import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Full-screen fallback shown when the cart fails to load.
class CartErrorView extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;
  final VoidCallback? onGoShopping;

  const CartErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.onGoShopping,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppEmptyState(
      icon: AppErrorCard.iconFor(error),
      iconColor: AppColors.error,
      title: l10n.cartLoadError,
      subtitle: AppErrorCard.messageFor(error, l10n),
      actionText: l10n.retry,
      actionIcon: Icons.refresh_rounded,
      onActionTap: onRetry,
      secondaryActionText: l10n.continueShopping,
      onSecondaryActionTap: onGoShopping,
    );
  }
}
