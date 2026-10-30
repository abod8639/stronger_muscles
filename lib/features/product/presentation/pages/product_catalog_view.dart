import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/product/presentation/widgets/app_product_grid.dart';
import 'package:stronger_muscles/features/product/presentation/widgets/product_grid_skeleton.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles/features/product/presentation/widgets/category_chip_selector.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Clean Architecture presentation page for exploring and filtering the product catalog.
/// Implements pagination support (`isLoadingMore`), debounced search, and responsive layout.
class ProductCatalogView extends ConsumerStatefulWidget {
  final String? initialCategoryId;

  const ProductCatalogView({super.key, this.initialCategoryId});

  @override
  ConsumerState<ProductCatalogView> createState() => _ProductCatalogViewState();
}

class _ProductCatalogViewState extends ConsumerState<ProductCatalogView> {
  final _searchController = TextEditingController();
  late String _selectedCategory = widget.initialCategoryId ?? '';

  ProductsController get _notifier => ref.read(productsControllerProvider.notifier);

  String? get _categoryFilter => _selectedCategory.isEmpty ? null : _selectedCategory;

  bool get _hasFilters => _selectedCategory.isNotEmpty || _searchController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_selectedCategory.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifier.filterByCategory(_selectedCategory);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() => _notifier.fetchProducts(
        categoryId: _categoryFilter,
        query: _searchController.text,
        refresh: true,
      );

  void _onCategorySelected(String categoryId) {
    setState(() => _selectedCategory = categoryId);
    _notifier.fetchProducts(categoryId: _categoryFilter);
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() => _selectedCategory = '');
    _notifier.fetchProducts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: baseAppBar(context, l10n.allProducts),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _reload,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.spacingLg,
                  AppDimens.spacingSm,
                  AppDimens.spacingLg,
                  0,
                ),
                child: AppSearchField(
                  controller: _searchController,
                  hintText: l10n.searchProducts,
                  onChanged: _notifier.searchWithDebounce,
                  onClear: () {
                    _searchController.clear();
                    _notifier.searchWithDebounce('');
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CategoryChipSelector(
                selectedCategoryId: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),
            ),
            productsState.when(
              data: (products) => products.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppEmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: l10n.noProductsFound,
                        subtitle: l10n.searchForProducts,
                        secondaryActionText: _hasFilters ? l10n.clearFilters : null,
                        onSecondaryActionTap: _hasFilters ? _clearFilters : null,
                      ),
                    )
                  : AppProductGrid(
                      products: products,
                      isLoadingMore: productsState.isLoadingMore,
                      onNearEnd: _notifier.loadMoreProducts,
                      onProductTap: (product) =>
                          context.push(AppRoutes.productDetails, extra: product),
                    ),
              loading: () => const ProductGridSkeleton(itemCount: 6),
              error: (error, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: AppEmptyState(
                  icon: AppErrorCard.iconFor(error),
                  iconColor: AppColors.error,
                  title: AppErrorCard.messageFor(error, l10n),
                  actionText: l10n.retry,
                  actionIcon: Icons.refresh_rounded,
                  onActionTap: _reload,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimens.spacingLg)),
          ],
        ),
      ),
    );
  }
}
