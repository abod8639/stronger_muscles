import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/components/product_grid_skeleton.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/core/utils/responsive_helper.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class ProductList extends ConsumerWidget {
  static const double _horizontalPadding = 8.0;
  static const double _mainAxisSpacing = 12.0;
  static const double _crossAxisSpacing = 8.0;

  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return homeState.when(
      data: (products) {
        // Optimistic loading: old products stay visible while new section loads.
        // isSectionSwitching = true means fetch is in-flight but data is still shown.
        final isSwitching = ref.watch(
          homeControllerProvider.notifier.select((n) => n.isSectionSwitching),
        );

        // Empty state only when truly empty and not in the middle of a switch
        if (products.isEmpty && !isSwitching) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: AppEmptyState(
                icon: Icons.inventory_2_outlined,
                title: l10n?.noProductsFound ?? 'لا توجد منتجات متوفرة حالياً',
              ),
            ),
          );
        }

        // During a section switch with no stale products yet — show skeleton grid
        if (products.isEmpty && isSwitching) {
          return const ProductGridSkeleton(itemCount: 6);
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
              const SliverToBoxAdapter(
                child: LinearProgressIndicator(minHeight: 2.5),
              ),

            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              sliver: SliverMainAxisGroup(
                slivers: [
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          ResponsiveHelper.getGridCrossAxisCount(context),
                      childAspectRatio:
                          ResponsiveHelper.getGridChildAspectRatio(context),
                      crossAxisSpacing: _crossAxisSpacing,
                      mainAxisSpacing: _mainAxisSpacing,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < 0 || index >= products.length) {
                          return const SizedBox.shrink();
                        }

                        // Trigger pagination when reaching the last 4 items
                        if (index == products.length - 4 &&
                            hasMore &&
                            !isLoadingMore) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final selectedIndex = ref
                                .read(homeControllerProvider.notifier)
                                .selectedSectionIndex;
                            final sections = ref
                                .read(
                                  categoriesSectionsControllerProvider,
                                )
                                .valueOrNull;
                            String? categoryId;
                            if (sections != null &&
                                selectedIndex >= 0 &&
                                selectedIndex < sections.length) {
                              final id = sections[selectedIndex].id;
                              categoryId = id.isEmpty ? null : id;
                            }
                            ref
                                .read(homeControllerProvider.notifier)
                                .loadMoreProducts(categoryId: categoryId);
                          });
                        }

                        final product = products[index];
                        return GestureDetector(
                          onTap: () => context.push(
                            AppRoutes.productDetails,
                            extra: product,
                          ),
                          child: AppProductCard.fromEntity(
                            entity: product,
                            showName: true,
                            isBackgroundWhite: false,
                          ),
                        );
                      },
                      childCount: products.length,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: true,
                    ),
                  ),
                  if (isLoadingMore)
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
          ],
        );
      },

      // First-time load: show skeleton grid instead of a full-screen spinner.
      loading: () => const ProductGridSkeleton(itemCount: 6),

      error: (error, stack) {
        final errorMessage = error is Failure
            ? error.toMessage()
            : (error is String
                ? error
                : (l10n?.error ??
                    'حدث خطأ غير متوقع، يرجى إعادة المحاولة لاحقاً'));

        final isNetwork = error is Failure && error.isConnectionError;

        return SliverToBoxAdapter(
          child: Center(
            heightFactor: 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isNetwork
                        ? Icons.wifi_off_rounded
                        : Icons.error_outline_rounded,
                    size: 56.0,
                    color: theme.colorScheme.error.withValues(alpha: .7),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  AppPrimaryButton(
                    text: l10n?.retry ?? 'إعادة المحاولة',
                    icon: Icons.refresh_rounded,
                    height: 44.0,
                    onPressed: () {
                      final selectedIndex = ref
                          .read(homeControllerProvider.notifier)
                          .selectedSectionIndex;
                      final sectionsState =
                          ref.read(categoriesSectionsControllerProvider);
                      String? categoryId;
                      if (sectionsState.hasValue &&
                          selectedIndex >= 0 &&
                          selectedIndex <
                              (sectionsState.value?.length ?? 0)) {
                        final id =
                            sectionsState.value![selectedIndex].id;
                        categoryId = id.isEmpty ? null : id;
                      }
                      ref
                          .read(homeControllerProvider.notifier)
                          .fetchProductsForSection(
                            selectedIndex,
                            categoryId: categoryId,
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
