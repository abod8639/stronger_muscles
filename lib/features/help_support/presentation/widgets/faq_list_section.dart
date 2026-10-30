import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/presentation/utils/help_support_ui.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// FAQ accordion list, or an empty state with a "reset search" action.
class FaqListSection extends StatelessWidget {
  final List<FaqEntity> faqs;
  final VoidCallback? onResetSearch;

  const FaqListSection({
    super.key,
    required this.faqs,
    this.onResetSearch,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = context.isArabic;

    if (faqs.isEmpty) {
      return AppCard(
        margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
        borderRadius: AppRadius.allXl,
        child: AppEmptyState(
          icon: Icons.search_off_rounded,
          title: l10n?.noFaqsFound ?? 'لم يتم العثور على نتائج مطابقة',
          subtitle: l10n?.tryDifferentKeywords,
          padding: const EdgeInsets.all(AppDimens.spacingXl),
          secondaryActionText: l10n?.resetSearch,
          onSecondaryActionTap: onResetSearch,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
      child: Column(
        children: [
          for (final faq in faqs)
            AppAccordionTile(
              margin: const EdgeInsets.only(bottom: 10.0),
              badge: AppBadge(
                label: faq.category.label(l10n),
                color: AppColors.primary,
                borderRadius: AppRadius.allSm,
              ),
              title: faq.getQuestion(isArabic),
              content: Text(
                faq.getAnswer(isArabic),
                style: context.textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
