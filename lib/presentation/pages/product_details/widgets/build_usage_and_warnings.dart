import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Widget buildUsageAndWarnings(ProductModel product, bool isDark) {
  final hasUsage =
      product.usageInstructions != null &&
      product.usageInstructions!.isNotEmpty;
  final hasWarnings = product.warnings.isNotEmpty;

  if (!hasUsage && !hasWarnings) return const SizedBox.shrink();

  return Builder(
    builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Usage Instructions
          if (hasUsage) ...[
            Text(
              AppLocalizations.of(context)!.usageInstructions,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      product.usageInstructions!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.white : AppColors.black,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Warnings
          if (hasWarnings) ...[
            Text(
              AppLocalizations.of(context)!.warnings,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            ...product.warnings.map((warning) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        warning,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.white : AppColors.black,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      );
    },
  );
}
