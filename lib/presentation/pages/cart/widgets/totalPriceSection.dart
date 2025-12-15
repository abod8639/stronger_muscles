



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';

const double _totalLabelFontSize = 14.0;

   const double _totalPriceFontSize = 24.0;

   const double _itemCountFontSize = 12.0;

   const double _smallSpacing = 4.0;

  final controller = Get.find<CartController>();


  Widget totalPriceSection() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.total,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: _totalLabelFontSize,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        '${controller.cartItems.length} ${controller.cartItems.length == 1 ? AppLocalizations.of(context)!.item : AppLocalizations.of(context)!.items}',
                        style: TextStyle(
                          fontSize: _itemCountFontSize,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _smallSpacing),
              Obx(
                () => Text(
                  '\$${controller.totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: _totalPriceFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

