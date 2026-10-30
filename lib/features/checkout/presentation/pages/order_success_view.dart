import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Order placed confirmation page built on [AppEmptyState].
class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: AppEmptyState(
          icon: Icons.check_rounded,
          iconColor: AppColors.success,
          title: l10n.orderPlacedSuccessfully,
          subtitle: l10n.orderPlacedThankYou,
          actionText: l10n.continueShopping,
          actionIcon: Icons.storefront_outlined,
          onActionTap: () => context.go(AppRoutes.main),
          secondaryActionText: l10n.orders,
          onSecondaryActionTap: () {
            context.go(AppRoutes.main);
            context.push(AppRoutes.orderView);
          },
        ),
      ),
    );
  }
}
