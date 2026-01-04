import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/product_container.dart';
import 'package:stronger_muscles/core/utils/responsive_helper.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';

/// Grid view of products displayed on the home page
class ProductList extends StatelessWidget {
  static const double _horizontalPadding = 8.0;
  static const double _mainAxisSpacing = 12.0;
  static const double _crossAxisSpacing = 8.0;

  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final theme = Theme.of(context);

    return Obx(() {
      // Loading state
      if (controller.isLoading.value) {
        return const SliverToBoxAdapter(
          child: Center(heightFactor: 3, child: CircularProgressIndicator()),
        );
      }

      // Error state
      if (controller.isError.value) {
        return SliverToBoxAdapter(
          child: Center(
            heightFactor: 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    controller.isConnectionError.value ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
                    size: 64.0,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  if (controller.isConnectionError.value) ...[
                    const SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: () => controller.fetchProductsForSection(controller.selectedSectionIndex.value),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة محاولة'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }

      // Empty state
      if (controller.products.isEmpty) {

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

      // Product grid
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
            childAspectRatio: ResponsiveHelper.getGridChildAspectRatio(context),
            crossAxisSpacing: _crossAxisSpacing,
            mainAxisSpacing: _mainAxisSpacing,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final product = controller.products[index];
            return GestureDetector(
              onTap: () => Get.to(
                () => ProductDetailsView(product: product),
                transition: Transition.fadeIn,
              ),
              child: ProductContainer(showName: true, product: product ),
            );
          }, childCount: controller.products.length),
        ),
      );
    });
  }
}

/// Legacy function for backward compatibility.
///
/// **Deprecated**: Use [ProductList] widget instead.
@Deprecated('Use ProductList widget instead')
Widget productList() {
  final controller = Get.find<HomeController>();
  return Builder(
    builder: (context) {
      return Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.products.isEmpty) {
          return const Center(child: Text('No products found.'));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return GestureDetector(
                onTap: () => Get.to(() => ProductDetailsView(product: product)),
                child: ProductContainer(showName: true, product: product),
              );
            },
          ),
        );
      });
    },
  );
}
