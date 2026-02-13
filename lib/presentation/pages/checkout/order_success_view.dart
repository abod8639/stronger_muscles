import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/routes/routes.dart';

const String _successTitle = 'Order Placed Successfully!';
const String _successMessage =
    'Thank you for your purchase. Your order has been placed and is being processed.';
const String _continueButtonText = 'Continue Shopping';
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
                _successTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _messageSpacing),
              const Text(
                _successMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: _buttonSpacing),
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.main);
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
                child: const Text(_continueButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
