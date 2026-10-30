import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/home/home_feature.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/search_history_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Search field with instant suggestions: recent searches when empty,
/// otherwise ranked (exact → prefix → contains → fuzzy) product matches.
///
/// With [readOnly] it is just a tappable field (e.g. on the home header).
class ProductSearchAutocomplete extends ConsumerStatefulWidget {
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;

  const ProductSearchAutocomplete({
    super.key,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  ConsumerState<ProductSearchAutocomplete> createState() => _ProductSearchAutocompleteState();
}

class _ProductSearchAutocompleteState extends ConsumerState<ProductSearchAutocomplete> {
  static const double _maxOptionsHeight = 400.0;

  final _focusNode = FocusNode();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  List<Object> _suggestions(String rawQuery, List<ProductEntity> products, String locale) {
    final query = rawQuery.toLowerCase().trim();
    if (query.isEmpty) return ref.read(searchHistoryProvider);

    final exactMatches = <ProductEntity>[];
    final prefixMatches = <ProductEntity>[];
    final containsMatches = <ProductEntity>[];

    for (final product in products) {
      final fields = [
        product.getLocalizedName(locale: locale).toLowerCase(),
        (product.brand ?? '').toLowerCase(),
        (product.category?.getLocalizedName(locale: locale) ?? '').toLowerCase(),
      ];
      if (fields.any((f) => f == query)) {
        exactMatches.add(product);
      } else if (fields.any((f) => f.startsWith(query))) {
        prefixMatches.add(product);
      } else if (fields.any((f) => f.contains(query))) {
        containsMatches.add(product);
      }
    }

    final results = [...exactMatches, ...prefixMatches, ...containsMatches];
    if (results.isNotEmpty) return results.take(15).toList();

    // No structural match: fall back to fuzzy matching on name and brand.
    final fuse = Fuzzy<ProductEntity>(
      products,
      options: FuzzyOptions(
        keys: [
          WeightedKey(name: 'name', getter: (p) => p.getLocalizedName(locale: locale), weight: 1.0),
          WeightedKey(name: 'brand', getter: (p) => p.brand ?? '', weight: 0.7),
        ],
        threshold: 0.35,
      ),
    );
    return fuse.search(query).take(5).map((r) => r.item).toList();
  }

  void _onSelected(Object selection, String locale) {
    final controller = ref.read(productSearchControllerProvider.notifier);
    final history = ref.read(searchHistoryProvider.notifier);

    if (selection is ProductEntity) {
      final name = selection.getLocalizedName(locale: locale);
      history.add(name);
      controller.onSearchChanged(name);
      context.push(AppRoutes.productDetails, extra: selection);
    } else if (selection is String) {
      _textController.text = selection;
      controller.onSearchChanged(selection);
      history.add(selection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = l10n.localeName;

    if (widget.readOnly) {
      return AppSearchField(
        readOnly: true,
        hintText: l10n.searchProducts,
        onTap: widget.onTap,
      );
    }

    final products = ref.watch(homeControllerProvider).valueOrNull ?? const <ProductEntity>[];
    ref.watch(searchHistoryProvider);
    final controller = ref.read(productSearchControllerProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<Object>(
        textEditingController: _textController,
        focusNode: _focusNode,
        displayStringForOption: (option) =>
            option is ProductEntity ? option.getLocalizedName(locale: locale) : '$option',
        optionsBuilder: (value) => _suggestions(value.text, products, locale),
        onSelected: (selection) => _onSelected(selection, locale),
        fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) => AppSearchField(
          controller: textController,
          focusNode: focusNode,
          autofocus: widget.autofocus,
          hintText: l10n.searchProducts,
          onTap: widget.onTap,
          onChanged: controller.onSearchChanged,
          onSubmitted: (value) {
            ref.read(searchHistoryProvider.notifier).add(value);
            onFieldSubmitted();
          },
        ),
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
            padding: const EdgeInsets.only(top: AppDimens.spacingXs),
            child: Material(
              elevation: AppDimens.elevationMd,
              borderRadius: AppRadius.allLg,
              color: context.colorScheme.surface,
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: _maxOptionsHeight, maxWidth: constraints.maxWidth),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingSm),
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    indent: AppDimens.spacingLg,
                    endIndent: AppDimens.spacingLg,
                    color: context.colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return option is ProductEntity
                        ? _ProductSuggestion(
                            product: option,
                            query: _textController.text,
                            locale: locale,
                            onTap: () => onSelected(option),
                          )
                        : _HistorySuggestion(
                            term: '$option',
                            onTap: () => onSelected(option),
                            onRemove: () => ref.read(searchHistoryProvider.notifier).remove('$option'),
                          );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistorySuggestion extends StatelessWidget {
  final String term;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _HistorySuggestion({required this.term, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final mutedColor = context.colorScheme.onSurfaceVariant;

    return ListTile(
      dense: true,
      leading: Icon(Icons.history_rounded, size: AppDimens.iconSm, color: mutedColor),
      title: Text(term, style: context.textTheme.bodyMedium),
      trailing: IconButton(
        icon: Icon(Icons.close_rounded, size: 16, color: mutedColor),
        onPressed: onRemove,
      ),
      onTap: onTap,
    );
  }
}

class _ProductSuggestion extends StatelessWidget {
  static const double _thumbSize = 48.0;

  final ProductEntity product;
  final String query;
  final String locale;
  final VoidCallback onTap;

  const _ProductSuggestion({
    required this.product,
    required this.query,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final brand = product.brand;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingLg,
          vertical: AppDimens.spacingMd,
        ),
        child: Row(
          children: [
            AppNetworkImage(
              imageUrl: product.primaryThumbnailUrl,
              width: _thumbSize,
              height: _thumbSize,
              borderRadius: AppRadius.allSm,
            ),
            const SizedBox(width: AppDimens.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppHighlightText(
                    text: product.getLocalizedName(locale: locale),
                    query: query,
                    style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (brand != null && brand.isNotEmpty)
                    Text(
                      brand,
                      style: textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spacingSm),
            AppPriceText(price: product.baseEffectivePrice, fontSize: 13.0),
          ],
        ),
      ),
    );
  }
}
