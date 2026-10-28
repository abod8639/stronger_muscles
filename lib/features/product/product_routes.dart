import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/product/presentation/pages/product_catalog_view.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Dedicated modular routing configuration for Product feature.
class ProductRoutes {
  const ProductRoutes._();

  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.products,
      builder: (context, state) {
        final extra = state.extra;
        final categoryId = extra is String ? extra : null;
        return ProductCatalogView(initialCategoryId: categoryId);
      },
    ),
  ];
}
