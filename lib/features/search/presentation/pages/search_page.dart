import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/components/product_grid_skeleton.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
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
    final searchNotifier = ref.read(productSearchControllerProvider.notifier);
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
            child: _SearchFilterChip(label: l10n.searchForProducts),
          ),
          searchState.when(
            data: (products) {
              if (searchNotifier.hasSearched && products.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    icon: Icons.search_off_rounded,
                    title: l10n.noResultsFound,
                    subtitle: l10n.searchForProducts,
                  ),
                );
              }

              return AppProductGrid(
                products: products,
                query: searchNotifier.searchQuery,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacingSm,
                  vertical: AppDimens.spacingLg,
                ),
                onProductTap: (product) =>
                    context.push(AppRoutes.productDetails, extra: product),
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
                onActionTap: () => searchNotifier.onSearchChanged(searchNotifier.searchQuery),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Isolated chip widget with selective listening to avoid rebuilding the whole page.
class _SearchFilterChip extends ConsumerWidget {
  final String label;

  const _SearchFilterChip({required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(
      productSearchControllerProvider.notifier.select((n) => n.searchQuery),
    );
    if (query.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLg,
        vertical: AppDimens.spacingSm,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: InputChip(
          avatar: const Icon(Icons.search_rounded, size: 18, color: AppColors.primary),
          label: Text('$label: $query'),
          labelStyle: context.textTheme.labelLarge?.copyWith(color: AppColors.primary),
          backgroundColor: AppColors.primary.withValues(alpha: 0.08),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
          shape: AppRadius.shapePill,
          deleteIconColor: AppColors.primary,
          onDeleted: () => ref.read(productSearchControllerProvider.notifier).clearSearch(),
        ),
      ),
    );
  }
}
