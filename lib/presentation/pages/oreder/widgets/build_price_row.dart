

import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';

Widget buildPriceRow(String label, double amount, bool isAr, {bool isTotal = false, bool isDiscount = false}) {
    return Builder(
      builder: (context) {
    final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isTotal ? null : Colors.grey,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 16 : 14,
                ),
              ),
              Text(
                '${amount.toStringAsFixed(2)} ${isAr ? "ج.م" : "EGP"}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDiscount ? AppColors.success : (isTotal ? AppColors.primary : null),
                  fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
                  fontSize: isTotal ? 18 : 14,
                ),
              ),
            ],
          ),
        );
      }
    );
  }

