import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/routes/routes.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _iconSize = 100.0;
const double _headlineSpacing = 24.0;
const double _messageSpacing = 16.0;
const double _buttonSpacing = 32.0;
const double _contentPadding = 24.0;
const double _buttonHorizontalPadding = 32.0;
const double _buttonVerticalPadding = 16.0;
const double _buttonBorderRadius = 12.0;

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(_contentPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: _iconSize,
                color: AppColors.success,
              ),
              const SizedBox(height: _headlineSpacing),
              Text(
                l10n.orderPlacedSuccessfully,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _messageSpacing),
              Text(
                l10n.orderPlacedThankYou,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: _buttonSpacing),
              ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.main);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: _buttonHorizontalPadding,
                    vertical: _buttonVerticalPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_buttonBorderRadius),
                  ),
                ),
                child: Text(l10n.continueShopping),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
