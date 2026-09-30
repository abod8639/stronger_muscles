import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/product_container.dart';
import 'package:stronger_muscles/core/utils/responsive_helper.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_bar_inline.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';
import '../controllers/product_search_controller.dart';

class SearchPage extends ConsumerWidget {
  final bool isFocused;
  const SearchPage({super.key, this.isFocused = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(productSearchControllerProvider);
    final searchNotifier = ref.watch(productSearchControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
           SliverAppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            pinned: false,
            floating: true,
            snap: true,
            centerTitle: true,
            title: Hero(
              tag: 'searchBar',
              child: Material(
                color: Colors.transparent,
                child: SearchBarInline(
                  
                  isFocused: isFocused),
              ),
            ),
          ),

          SliverToBoxAdapter(child: _buildFilterChips(ref,l10n.searchForProducts)),

          searchState.when(
            data: (products) {
              // Show nothing if query is empty and we haven't searched (initial state)
              // Or show all products if that's the intended initial state
              final displayedProducts = products;

              if (searchNotifier.hasSearched && displayedProducts.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmptyState(l10n.noResultsFound));
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacingSm,
                  vertical: AppDimens.spacingLg,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
                      context,
                    ),
                    childAspectRatio: ResponsiveHelper.getGridChildAspectRatio(
                      context,
                    ),
                    crossAxisSpacing: AppDimens.spacingSm,
                    mainAxisSpacing: AppDimens.spacingMd,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = displayedProducts[index];
                    return GestureDetector(
                      onTap: () => context.push(
                        AppRoutes.productDetails,
                        extra: product,
                      ),
                      child: ProductContainer(
                        showName: true,
                        product: product,
                        isBackgroundWhite: false,
                        query: searchNotifier.searchQuery,
                      ),
                    );
                  }, childCount: displayedProducts.length),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(
                heightFactor: 3,
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, st) =>
                SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: AppDimens.iconXl, color: Colors.grey[400]),
          const SizedBox(height: AppDimens.spacingLg),
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(WidgetRef ref , String lable) {
    final query = ref
        .watch(productSearchControllerProvider.notifier)
        .searchQuery;
    if (query.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg, vertical: AppDimens.spacingSm),
      alignment: Alignment.centerRight,
      child: Chip(
        label: Text('$lable $query'),
        onDeleted: () =>
            ref.read(productSearchControllerProvider.notifier).clearSearch(),
      ),
    );
  }
}
