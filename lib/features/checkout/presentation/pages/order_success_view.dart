import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

const double _iconSize = 96.0;

/// Order placed confirmation page using unified [AppPrimaryButton].
class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimens.spacingLg),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: _iconSize,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppDimens.spacingXl),
              Text(
                l10n.orderPlacedSuccessfully,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.spacingMd),
              Text(
                l10n.orderPlacedThankYou,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: 240.0,
                child: AppPrimaryButton(
                  text: l10n.continueShopping,
                  icon: Icons.storefront_outlined,
                  onPressed: () => context.go(AppRoutes.main),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
