import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class FaqCategoriesChips extends StatelessWidget {
  final FaqCategory selectedCategory;
  final ValueChanged<FaqCategory> onSelectCategory;

  const FaqCategoriesChips({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  String _getCategoryLabel(BuildContext context, FaqCategory category) {
    final l10n = AppLocalizations.of(context);
    switch (category) {
      case FaqCategory.all:
        return l10n?.allCategories ?? 'الكل';
      case FaqCategory.ordersShipping:
        return l10n?.categoryOrdersShipping ?? 'الطلبات والتوصيل';
      case FaqCategory.supplements:
        return l10n?.categorySupplements ?? 'المكملات والجودة';
      case FaqCategory.paymentRefunds:
        return l10n?.categoryPaymentRefunds ?? 'الدفع والاسترجاع';
      case FaqCategory.accountGeneral:
        return l10n?.categoryAccountGeneral ?? 'الحساب والاستشارات';
    }
  }

  IconData _getCategoryIcon(FaqCategory category) {
    switch (category) {
      case FaqCategory.all:
        return Icons.auto_awesome_rounded;
      case FaqCategory.ordersShipping:
        return Icons.local_shipping_outlined;
      case FaqCategory.supplements:
        return Icons.fitness_center_rounded;
      case FaqCategory.paymentRefunds:
        return Icons.account_balance_wallet_outlined;
      case FaqCategory.accountGeneral:
        return Icons.health_and_safety_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    const categories = FaqCategory.values;

    return SizedBox(
      height: 42.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelectCategory(cat),
              borderRadius: AppRadius.allPill,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                  borderRadius: AppRadius.allPill,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.white12 : AppColors.greyMedium.withValues(alpha: 0.6)),
                    width: 1.0,
                  ),
                  boxShadow: isSelected
                      ? AppShadows.colored(AppColors.primary, alpha: 0.28, blur: 8.0)
                      : (isDark ? null : AppShadows.subtle()),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getCategoryIcon(cat),
                      size: 16.0,
                      color: isSelected
                          ? AppColors.white
                          : (isDark ? AppColors.grey : AppColors.greyDark),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      _getCategoryLabel(context, cat),
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? AppColors.white
                            : (isDark ? AppColors.white : AppColors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
