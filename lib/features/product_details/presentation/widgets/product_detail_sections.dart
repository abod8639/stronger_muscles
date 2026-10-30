import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/search/search_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Expandable product description.
class ProductDescriptionSection extends StatelessWidget {
  final ProductModel product;

  const ProductDescriptionSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final description = product.getLocalizedDescription(
      locale: Localizations.localeOf(context).languageCode,
    );
    if (description.isEmpty) return const SizedBox.shrink();

    return AppSectionCard(
      title: l10n.productDescription,
      icon: Icons.description_outlined,
      child: AppExpandableText(
        text: description,
        expandText: l10n.readMore,
        collapseText: l10n.readLess,
        style: context.textTheme.bodyLarge?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
          height: 1.6,
        ),
      ),
    );
  }
}

/// Key/value product specs (brand links to a brand search).
class ProductInfoSection extends ConsumerWidget {
  final ProductModel product;

  const ProductInfoSection({super.key, required this.product});

  void _searchBrand(BuildContext context, WidgetRef ref, String brand) {
    final searchNotifier = ref.read(productSearchControllerProvider.notifier);
    searchNotifier.clearSearch();
    searchNotifier.textController.text = brand;
    searchNotifier.updateSearchQuery(brand);
    context.push(AppRoutes.search, extra: false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final brand = product.brand;
    final category = product.category;

    final rows = <({String label, String value})>[
      if (category?.name != null) (label: l10n.category, value: category!.getLocalizedName(locale: locale)),
      if (product.sku != null) (label: l10n.sku, value: product.sku!),
      if (product.servingSize != null) (label: l10n.servingSize, value: product.servingSize!),
      (label: l10n.servingsPerContainer, value: '${product.servingsPerContainer}'),
      if (product.weight != null) (label: l10n.weight, value: '${product.weight} ${l10n.kg}'),
      if (product.manufacturer != null) (label: l10n.manufacturer, value: product.manufacturer!),
      if (product.countryOfOrigin != null) (label: l10n.countryOfOrigin, value: product.countryOfOrigin!),
    ];
    final divider = Divider(height: AppDimens.spacingLg, color: context.colorScheme.outlineVariant.withValues(alpha: 0.5));

    return AppSectionCard(
      title: l10n.productInfo,
      icon: Icons.info_outline_rounded,
      child: Column(
        children: [
          if (brand != null && brand.isNotEmpty) ...[
            AppInfoRow(
              label: l10n.brand,
              value: brand,
              valueWidget: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AppLinkButton(
                  text: brand,
                  color: AppColors.info,
                  padding: EdgeInsets.zero,
                  onPressed: () => _searchBrand(context, ref, brand),
                ),
              ),
            ),
            divider,
          ],
          for (final (index, row) in rows.indexed) ...[
            if (index > 0) divider,
            AppInfoRow(label: row.label, value: row.value),
          ],
        ],
      ),
    );
  }
}

/// Ingredient tags.
class ProductIngredientsSection extends StatelessWidget {
  final ProductModel product;

  const ProductIngredientsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    if (product.ingredients.isEmpty) return const SizedBox.shrink();
    final mutedColor = context.colorScheme.onSurfaceVariant;

    return AppSectionCard(
      title: AppLocalizations.of(context)!.ingredients,
      icon: Icons.eco_outlined,
      child: Wrap(
        spacing: AppDimens.spacingSm,
        runSpacing: AppDimens.spacingSm,
        children: [
          for (final ingredient in product.ingredients)
            AppBadge(
              label: ingredient,
              color: mutedColor,
              alpha: 0.08,
              borderRadius: AppRadius.allPill,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              textStyle: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

/// Usage instructions and safety warnings.
class ProductUsageSection extends StatelessWidget {
  final ProductModel product;

  const ProductUsageSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final usage = product.usageInstructions;
    final hasUsage = usage != null && usage.isNotEmpty;
    final hasWarnings = product.warnings.isNotEmpty;

    if (!hasUsage && !hasWarnings) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasUsage)
          AppSectionCard(
            title: l10n.usageInstructions,
            icon: Icons.menu_book_outlined,
            child: Text(
              usage,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        if (hasUsage && hasWarnings) const SizedBox(height: AppDimens.spacingMd),
        if (hasWarnings)
          AppSectionCard(
            title: l10n.warnings,
            icon: Icons.warning_amber_rounded,
            child: Column(
              children: [
                for (final (index, warning) in product.warnings.indexed)
                  AppAlertCard(
                    color: AppColors.error,
                    icon: Icons.warning_amber_rounded,
                    message: warning,
                    margin: EdgeInsets.only(top: index == 0 ? 0 : AppDimens.spacingSm),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
