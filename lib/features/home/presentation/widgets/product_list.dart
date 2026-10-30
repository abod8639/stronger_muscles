import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/components/product_grid_skeleton.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Paginated product grid for the selected home section.
class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  /// Category id of the currently selected section (`null` = all products).
  static String? _selectedCategoryId(WidgetRef ref) {
    final selectedIndex = ref.read(homeControllerProvider.notifier).selectedSectionIndex;
    final sections = ref.read(categoriesSectionsControllerProvider).valueOrNull;
    if (sections == null || selectedIndex < 0 || selectedIndex >= sections.length) {
      return null;
    }
    final id = sections[selectedIndex].id;
    return id.isEmpty ? null : id;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final l10n = AppLocalizations.of(context);

    return homeState.when(
      data: (products) {
        // Optimistic loading: old products stay visible while new section loads.
        final isSwitching = ref.watch(
          homeControllerProvider.notifier.select((n) => n.isSectionSwitching),
        );

        if (products.isEmpty) {
          return isSwitching
              ? const ProductGridSkeleton(itemCount: 6)
              : SliverToBoxAdapter(
                  child: AppEmptyState(
                    fillHeight: false,
                    icon: Icons.inventory_2_outlined,
                    title: l10n?.noProductsFound ?? 'لا توجد منتجات متوفرة حالياً',
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacingXl,
                      vertical: 48.0,
                    ),
                  ),
                );
        }

        final isLoadingMore = ref.watch(
          homeControllerProvider.notifier.select((n) => n.isLoadingMore),
        );
        final hasMore = ref.watch(
          homeControllerProvider.notifier.select((n) => n.hasMore),
        );

        return SliverMainAxisGroup(
          slivers: [
            // A thin progress bar hints that a section switch is loading,
            // without hiding any product cards.
            if (isSwitching)
              const SliverToBoxAdapter(child: LinearProgressIndicator(minHeight: 2.5)),
            AppProductGrid(
              products: products,
              isLoadingMore: isLoadingMore,
              onNearEnd: hasMore
                  ? () => ref
                      .read(homeControllerProvider.notifier)
                      .loadMoreProducts(categoryId: _selectedCategoryId(ref))
                  : null,
              onProductTap: (product) => context.push(AppRoutes.productDetails, extra: product),
            ),
          ],
        );
      },

      // First-time load: show skeleton grid instead of a full-screen spinner.
      loading: () => const ProductGridSkeleton(itemCount: 6),

      error: (error, _) => SliverToBoxAdapter(
        child: AppEmptyState(
          fillHeight: false,
          icon: AppErrorCard.iconFor(error),
          iconColor: AppColors.error,
          title: AppErrorCard.messageFor(error, l10n),
          actionText: l10n?.retry ?? 'إعادة المحاولة',
          actionIcon: Icons.refresh_rounded,
          onActionTap: () => ref.read(homeControllerProvider.notifier).fetchProductsForSection(
                ref.read(homeControllerProvider.notifier).selectedSectionIndex,
                categoryId: _selectedCategoryId(ref),
              ),
        ),
      ),
    );
  }
}
