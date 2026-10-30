import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/components/product_grid_skeleton.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/responsive_helper.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Paginated product grid for the selected home section.
class ProductList extends ConsumerWidget {
  static const double _horizontalPadding = 8.0;
  static const double _mainAxisSpacing = 12.0;
  static const double _crossAxisSpacing = 8.0;

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
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
                  childAspectRatio: ResponsiveHelper.getGridChildAspectRatio(context),
                  crossAxisSpacing: _crossAxisSpacing,
                  mainAxisSpacing: _mainAxisSpacing,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Trigger pagination when reaching the last 4 items
                    if (index == products.length - 4 && hasMore && !isLoadingMore) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref
                            .read(homeControllerProvider.notifier)
                            .loadMoreProducts(categoryId: _selectedCategoryId(ref));
                      });
                    }

                    final product = products[index];
                    return AppProductCard.fromEntity(
                      entity: product,
                      onTap: () => context.push(AppRoutes.productDetails, extra: product),
                    );
                  },
                  childCount: products.length,
                  addAutomaticKeepAlives: false,
                ),
              ),
            ),
            if (isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppDimens.spacingLg),
                  child: Center(
                    child: SizedBox.square(
                      dimension: 24.0,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                ),
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
