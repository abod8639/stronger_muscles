import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/utils/responsive_helper.dart';
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
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController()..addListener(_onScroll);
    _selectedCategory = widget.initialCategoryId ?? '';
    if (_selectedCategory.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(productsControllerProvider.notifier)
            .filterByCategory(_selectedCategory);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      ref.read(productsControllerProvider.notifier).loadMoreProducts();
    }
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
    });
    ref
        .read(productsControllerProvider.notifier)
        .fetchProducts(categoryId: categoryId.isEmpty ? null : categoryId);
  }

  void _onSearchChanged(String query) {
    ref
        .read(productsControllerProvider.notifier)
        .searchWithDebounce(query);
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsControllerProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.featured ?? 'Products'),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(productsControllerProvider.notifier).fetchProducts(
                categoryId:
                    _selectedCategory.isEmpty ? null : _selectedCategory,
                query: _searchController.text,
                refresh: true,
              );
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Search field
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
                child: AppSearchField(
                  controller: _searchController,
                  hintText: l10n?.searchProducts ?? 'Search products...',
                  onChanged: _onSearchChanged,
                  onClear: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                ),
              ),
            ),

            // Category Chips
            SliverToBoxAdapter(
              child: CategoryChipSelector(
                selectedCategoryId: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),
            ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AppSectionTitle(
                  title: l10n?.mostPopularOffers ?? 'All Products',
                ),
              ),
            ),

            // Products Grid
            productsState.when(
              data: (products) {
                if (products.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: AppEmptyState(
                          icon: Icons.inventory_2_outlined,
                          title: l10n?.noProductsFound ?? 'No products found',
                          subtitle: l10n?.searchForProducts ??
                              'Try adjusting your search or category filter.',
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          ResponsiveHelper.getGridCrossAxisCount(context),
                      childAspectRatio:
                          ResponsiveHelper.getGridChildAspectRatio(context),
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return AppProductCard.fromEntity(
                          entity: product,
                          onTap: () => context.push(
                            AppRoutes.productDetails,
                            extra: product,
                          ),
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 56.0,
                          color: theme.colorScheme.error.withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          err.toString(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        AppPrimaryButton(
                          text: l10n?.retry ?? 'Retry',
                          icon: Icons.refresh_rounded,
                          width: 140.0,
                          height: 44.0,
                          onPressed: () => ref
                              .read(productsControllerProvider.notifier)
                              .fetchProducts(
                                categoryId: _selectedCategory.isEmpty
                                    ? null
                                    : _selectedCategory,
                                query: _searchController.text,
                                refresh: true,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Pagination loader at bottom
            if (productsState.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
