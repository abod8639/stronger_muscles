import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/core/utils/components/product_container.dart';
import 'package:stronger_muscles/core/utils/responsive_helper.dart';
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

    return homeState.when(
      data: (products) {
        if (products.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              heightFactor: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64.0,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'No products found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
              childAspectRatio: ResponsiveHelper.getGridChildAspectRatio(
                context,
              ),
              crossAxisSpacing: _crossAxisSpacing,
              mainAxisSpacing: _mainAxisSpacing,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () =>
                      context.push(AppRoutes.productDetails, extra: product),
                  child: ProductContainer(
                    showName: true,
                    product: product,
                    isBackgroundWhite: false,
                  ),
                );
              },
              childCount: products.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(heightFactor: 3, child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Center(
          heightFactor: 3,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64.0,
                  color: Colors.red.withValues(alpha: .5),
                ),
                const SizedBox(height: 16.0),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () => ref
                      .read(homeControllerProvider.notifier)
                      .fetchProductsForSection(
                        ref
                            .read(homeControllerProvider.notifier)
                            .selectedSectionIndex,
                      ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة محاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
