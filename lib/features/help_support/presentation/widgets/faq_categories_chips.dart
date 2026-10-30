import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/presentation/utils/help_support_ui.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Horizontal FAQ category filter.
class FaqCategoriesChips extends StatelessWidget {
  final FaqCategory selectedCategory;
  final ValueChanged<FaqCategory> onSelectCategory;

  const FaqCategoriesChips({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppChoiceChips<FaqCategory>(
      items: FaqCategory.values,
      selected: selectedCategory,
      onSelected: onSelectCategory,
      labelOf: (category) => category.label(l10n),
      iconOf: (category) => category.icon,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
    );
  }
}
