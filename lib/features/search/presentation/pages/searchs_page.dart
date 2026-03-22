import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/utils/components/product_container.dart';
import 'package:stronger_muscles/core/utils/responsive_helper.dart';
import 'package:stronger_muscles/routes/routes.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_bar.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import '../controllers/product_search_controller.dart';

class ProductSearchsPage extends ConsumerWidget {
  final bool isFocused;
  const ProductSearchsPage({super.key, this.isFocused = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(productSearchControllerProvider);
    final searchNotifier = ref.watch(productSearchControllerProvider.notifier);
    final homeProducts = ref.watch(homeControllerProvider).value ?? [];
    
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
                child: SearchBarInline(isFocused: isFocused),
              ),
            ),
          ),

          SliverToBoxAdapter(child: _buildFilterChips(ref)),

          searchState.when(
            data: (products) {
              final displayedProducts = searchNotifier.searchQuery.isEmpty
                  ? homeProducts
                  : products;

              if (searchNotifier.hasSearched && displayedProducts.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmptyState());
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
                      context,
                    ),
                    childAspectRatio: ResponsiveHelper.getGridChildAspectRatio(
                      context,
                    ),
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 12.0,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'لا توجد نتائج تطابق بحثك',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(WidgetRef ref) {
    final query = ref
        .watch(productSearchControllerProvider.notifier)
        .searchQuery;
    if (query.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerRight,
      child: Chip(
        label: Text('نتائج البحث عن: $query'),
        onDeleted: () =>
            ref.read(productSearchControllerProvider.notifier).clearSearch(),
      ),
    );
  }
}
