import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class FaqListSection extends StatelessWidget {
  final List<FaqEntity> faqs;
  final VoidCallback? onResetSearch;

  const FaqListSection({
    super.key,
    required this.faqs,
    this.onResetSearch,
  });

  String _getCategoryName(BuildContext context, FaqCategory category) {
    final l10n = AppLocalizations.of(context);
    switch (category) {
      case FaqCategory.all:
        return l10n?.allCategories ?? 'الكل';
      case FaqCategory.ordersShipping:
        return l10n?.categoryOrdersShipping ?? 'الطلبات';
      case FaqCategory.supplements:
        return l10n?.categorySupplements ?? 'المكملات';
      case FaqCategory.paymentRefunds:
        return l10n?.categoryPaymentRefunds ?? 'الدفع والاسترجاع';
      case FaqCategory.accountGeneral:
        return l10n?.categoryAccountGeneral ?? 'الحساب';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = context.isArabic;
    final isDark = context.isDark;

    if (faqs.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        padding: const EdgeInsets.all(28.0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: AppRadius.allXl,
          boxShadow: isDark ? null : AppShadows.soft(),
          border: Border.all(
            color: isDark ? Colors.white12 : AppColors.greyMedium.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 36.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14.0),
            Text(
              l10n?.noFaqsFound ?? 'لم يتم العثور على نتائج مطابقة',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              l10n?.tryDifferentKeywords ?? 'جرب استخدام كلمات بحث مختلفة أو تواصل معنا مباشرة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.0,
                color: isDark ? AppColors.grey : AppColors.greyDark,
              ),
            ),
            if (onResetSearch != null) ...[
              const SizedBox(height: 16.0),
              TextButton.icon(
                onPressed: onResetSearch,
                icon: const Icon(Icons.refresh_rounded, size: 18.0),
                label: const Text('إعادة ضبط البحث'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];

        return AppAccordionTile(
          margin: const EdgeInsets.only(bottom: 10.0),
          badge: AppBadge(
            label: _getCategoryName(context, faq.category),
            color: AppColors.primary,
            borderRadius: AppRadius.allSm,
          ),
          title: faq.getQuestion(isArabic),
          content: Text(
            faq.getAnswer(isArabic),
            style: TextStyle(
              fontSize: 14.0,
              height: 1.55,
              color: isDark ? AppColors.greyLight : const Color(0xFF424242),
            ),
          ),
        );
      },
    );
  }
}
