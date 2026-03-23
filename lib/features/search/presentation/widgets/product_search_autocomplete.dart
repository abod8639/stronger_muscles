
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/search_history_controller.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/highlight_text.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';


const double _borderRadius = 24.0;
const double _searchBarHeight = 48.0;


class ProductSearchAutocomplete extends ConsumerStatefulWidget {
  final bool autofocus;
  final bool readOnly;
  final Function()? onTap;

  const ProductSearchAutocomplete({
    super.key,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  ConsumerState<ProductSearchAutocomplete> createState() =>
      _ProductSearchAutocompleteState();
}

class _ProductSearchAutocompleteState
    extends ConsumerState<ProductSearchAutocomplete> {
  late FocusNode _focusNode;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.watch(productSearchControllerProvider.notifier);
    final homeProducts = ref.watch(homeControllerProvider).value ?? [];
    final searchHistory = ref.watch(searchHistoryProvider);
    final locale = l10n.localeName;

    Widget searchContainer(Widget field) => Container(
          height: _searchBarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(_borderRadius),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8.0),
              Expanded(child: field),
              if (_textController.text.isNotEmpty && !widget.readOnly)
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _textController.clear();
                    controller.onSearchChanged("");
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.clear,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        );

    if (widget.readOnly) {
      return searchContainer(
        TextField(
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          textInputAction: TextInputAction.search,
          onTap: widget.onTap,
          decoration: InputDecoration.collapsed(
            hintText: l10n.searchProducts,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<Object>(
        displayStringForOption: (option) {
          if (option is ProductModel) return option.getLocalizedName(locale: locale);
          if (option is String) return option;
          return "";
        },
        textEditingController: _textController,
        focusNode: _focusNode,
        optionsBuilder: (TextEditingValue textEditingValue) {
          final query = textEditingValue.text.toLowerCase().trim();

          // If query is empty, show search history
          if (query.isEmpty) {
            return searchHistory;
          }

          // Search Logic: Intelligent Filtering & Ranking
          final List<ProductModel> exactMatches = [];
          final List<ProductModel> prefixMatches = [];
          final List<ProductModel> containsMatches = [];

          for (final product in homeProducts) {
            final name = product.getLocalizedName(locale: locale).toLowerCase();
            final brand = (product.brand ?? "").toLowerCase();
            final category = (product.category?.getLocalizedName(locale: locale) ?? "").toLowerCase();

            if (name == query || brand == query || category == query) {
              exactMatches.add(product);
            } else if (name.startsWith(query) || brand.startsWith(query) || category.startsWith(query)) {
              prefixMatches.add(product);
            } else if (name.contains(query) || brand.contains(query) || category.contains(query)) {
              containsMatches.add(product);
            }
          }

          final results = [
            ...exactMatches,
            ...prefixMatches,
            ...containsMatches,
          ];

          // If no structural matches, try Fuzzy as fallback
          if (results.isEmpty) {
            final fuse = Fuzzy<ProductModel>(
              homeProducts,
              options: FuzzyOptions(
                keys: [
                  WeightedKey(
                    name: 'name',
                    getter: (p) => p.getLocalizedName(locale: locale),
                    weight: 1.0,
                  ),
                  WeightedKey(
                    name: 'brand',
                    getter: (p) => p.brand ?? "",
                    weight: 0.7,
                  ),
                ],
                threshold: 0.35,
              ),
            );
            return fuse.search(query).take(5).map((r) => r.item).toList();
          }

          return results.take(15).toList();
        },
        onSelected: (selection) {
          if (selection is ProductModel) {
            final name = selection.getLocalizedName(locale: locale);
            ref.read(searchHistoryProvider.notifier).add(name);
            controller.onSearchChanged(name);
            context.push(AppRoutes.productDetails, extra: selection);
          } else if (selection is String) {
            _textController.text = selection;
            controller.onSearchChanged(selection);
            ref.read(searchHistoryProvider.notifier).add(selection);
          }
        },
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          return searchContainer(
            TextField(
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: (val) {
                controller.onSearchChanged(val);
                setState(() {}); // For clear button
              },
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              textInputAction: TextInputAction.search,
              onSubmitted: (val) {
                ref.read(searchHistoryProvider.notifier).add(val);
                onFieldSubmitted();
              },
              onTap: widget.onTap,
              decoration: InputDecoration.collapsed(
                hintText: l10n.searchProducts,
              ),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.surface,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 400,
                  maxWidth: constraints.maxWidth,
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, indent: 16),
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);

                    // Search History Item UI
                    if (option is String) {
                      return ListTile(
                        leading: const Icon(Icons.history, size: 20),
                        title: Text(option),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => ref.read(searchHistoryProvider.notifier).remove(option),
                        ),
                        onTap: () => onSelected(option),
                      );
                    }

                    // Product Item UI
                    final product = option as ProductModel;
                    final query = _textController.text;
                    return InkWell(
                      onTap: () => onSelected(product),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: product.primaryThumbnailUrl ?? '',
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  child: const Icon(Icons.image, size: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  HighlightText(
                                    text: product.getLocalizedName(locale: locale),
                                    query: query,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (product.brand != null)
                                    Text(
                                      product.brand!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${product.price.toStringAsFixed(2)} LE',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(Icons.north_west, size: 14, color: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

