import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_bar_inline.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class SearchPage extends ConsumerStatefulWidget {
  final bool isFocused;
  final String? initialQuery;
  final String? initialBrand;

  const SearchPage({
    super.key,
    this.isFocused = false,
    this.initialQuery,
    this.initialBrand,
  });

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final notifier = ref.read(productSearchControllerProvider.notifier);
      if (widget.initialBrand != null && widget.initialBrand!.isNotEmpty) {
        notifier.searchByBrand(widget.initialBrand!);
      } else if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
        notifier.onSearchChanged(widget.initialQuery!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(productSearchControllerProvider);
    final searchNotifier = ref.read(productSearchControllerProvider.notifier);
    final isSearching = ref.watch(
      productSearchControllerProvider.notifier.select((n) => n.isSearching),
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            backgroundColor: context.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            floating: false,
            snap: false,
            centerTitle: true,
            title: Hero(
              tag: 'searchBar',
              child: Material(
                color: Colors.transparent,
                child: SearchBarInline(isFocused: widget.isFocused),
              ),
            ),
            bottom: isSearching
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(2.0),
                    child: LinearProgressIndicator(
                      minHeight: 2.0,
                      backgroundColor: Colors.transparent,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SliverToBoxAdapter(
            child: _SearchFilterChipsRow(),
          ),
          searchState.when(
            data: (products) {
              if (searchNotifier.hasSearched && products.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    icon: Icons.search_off_rounded,
                    title: l10n.noResultsFound,
                    subtitle: searchNotifier.selectedBrand != null
                        ? '${l10n.brand}: ${searchNotifier.selectedBrand}'
                        : l10n.searchForProducts,
                    actionText: l10n.clearFilters,
                    actionIcon: Icons.refresh_rounded,
                    onActionTap: () => searchNotifier.clearSearch(),
                  ),
                );
              }

              return SliverMainAxisGroup(
                slivers: [
                  if (products.isNotEmpty && searchNotifier.hasSearched)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spacingLg,
                          vertical: AppDimens.spacingXs,
                        ),
                        child: Text(
                          '${products.length} ${l10n.allProducts}',
                          style: context.textTheme.labelMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  AppProductGrid(
                    products: products,
                    query: searchNotifier.searchQuery,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacingSm,
                      vertical: AppDimens.spacingMd,
                    ),
                    onProductTap: (product) =>
                        context.push(AppRoutes.productDetails, extra: product),
                  ),
                ],
              );
            },
            loading: () => const ProductGridSkeleton(itemCount: 6),
            error: (error, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: AppEmptyState(
                icon: AppErrorCard.iconFor(error),
                iconColor: AppColors.error,
                title: AppErrorCard.messageFor(error, l10n),
                actionText: l10n.retry,
                actionIcon: Icons.refresh_rounded,
                onActionTap: () =>
                    searchNotifier.onSearchChanged(searchNotifier.searchQuery),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dynamic horizontal chips row showing active filters (Brand, Search Query, Price Range)
class _SearchFilterChipsRow extends ConsumerWidget {
  const _SearchFilterChipsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(productSearchControllerProvider.notifier);
    final brand = ref.watch(
      productSearchControllerProvider.notifier.select((n) => n.selectedBrand),
    );
    final query = ref.watch(
      productSearchControllerProvider.notifier.select((n) => n.searchQuery),
    );
    final isPriceActive = ref.watch(
      productSearchControllerProvider.notifier
          .select((n) => n.isPriceFilterActive),
    );

    final minPrice = notifier.filterMinPrice;
    final maxPrice = notifier.filterMaxPrice;

    final chips = <Widget>[];

    // 1. Brand Chip (Prominently displayed when searching by brand)
    if (brand != null && brand.isNotEmpty) {
      chips.add(
        InputChip(
          avatar: const Icon(Icons.verified_outlined,
              size: 16, color: AppColors.info ),
          label: Text('${l10n.brand}: $brand'),
          labelStyle: context.textTheme.labelMedium?.copyWith(
            color: AppColors.info,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColors.primary .withValues(alpha: 0.1),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
          shape: AppRadius.shapePill,
          deleteIconColor: AppColors.primary,
          onDeleted: () => notifier.clearBrandFilter(),
        ),
      );
    } else if (query.isNotEmpty) {
      // 2. Query Chip (when not already represented by brand)
      chips.add(
        InputChip(
          avatar: const Icon(Icons.search_rounded,
              size: 16, color: AppColors.primary),
          label: Text('${l10n.searchForProducts}: $query'),
          labelStyle:
              context.textTheme.labelMedium?.copyWith(color: AppColors.primary),
          backgroundColor: AppColors.primary.withValues(alpha: 0.08),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
          shape: AppRadius.shapePill,
          deleteIconColor: AppColors.primary,
          onDeleted: () => notifier.clearSearch(),
        ),
      );
    }

    // 3. Price Filter Chip
    if (isPriceActive) {
      final priceLabel =
          '${AppPriceText.format(minPrice, decimals: 0)} - ${AppPriceText.format(maxPrice, decimals: 0)}';
      chips.add(
        InputChip(
          avatar: const Icon(Icons.attach_money_rounded,
              size: 16, color: AppColors.primary),
          label: Text(priceLabel),
          labelStyle:
              context.textTheme.labelMedium?.copyWith(color: AppColors.primary),
          backgroundColor: AppColors.primary.withValues(alpha: 0.08),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
          shape: AppRadius.shapePill,
          deleteIconColor: AppColors.primary,
          onDeleted: () => notifier.resetPriceFilter(),
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLg,
        vertical: AppDimens.spacingSm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final chip in chips) ...[
              chip,
              const SizedBox(width: AppDimens.spacingSm),
            ],
            if (chips.length > 1)
              TextButton(
                onPressed: () => notifier.clearSearch(),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDimens.spacingSm),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.clearFilters,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
