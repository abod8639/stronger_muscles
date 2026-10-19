import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/responsive_helper.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_bar_inline.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

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
                child: SearchBarInline(isFocused: isFocused),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildFilterChips(ref, l10n.searchForProducts),
          ),
          searchState.when(
            data: (products) {
              final displayedProducts = products;

              if (searchNotifier.hasSearched && displayedProducts.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    icon: Icons.search_off_rounded,
                    title: l10n.noResultsFound,
                    subtitle: l10n.searchForProducts,
                  ),
                );
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
                      child: AppProductCard.fromEntity(
                        showName: true,
                        entity: product,
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

  Widget _buildFilterChips(WidgetRef ref, String label) {
    final query = ref.watch(productSearchControllerProvider.notifier).searchQuery;
    if (query.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLg,
        vertical: AppDimens.spacingSm,
      ),
      alignment: Alignment.centerRight,
      child: Chip(
        shape: AppRadius.shapePill,
        label: Text('$label $query'),
        onDeleted: () =>
            ref.read(productSearchControllerProvider.notifier).clearSearch(),
      ),
    );
  }
}
