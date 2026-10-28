import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/pages/product_details_view.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Modular routes for the Product Details feature.
class ProductDetailsRoutes {
  static List<RouteBase> get routes => [
        GoRoute(
          path: AppRoutes.productDetails,
          builder: (context, state) {
            final extra = state.extra;
            if (extra is ProductEntity) {
              return ProductDetailsView(product: extra);
            } else if (extra is ProductModel) {
              return ProductDetailsView.fromModel(model: extra);
            } else if (extra is Map<String, dynamic> &&
                extra.containsKey('product')) {
              final p = extra['product'];
              final productEntity = p is ProductEntity
                  ? p
                  : (p is ProductModel ? p.toEntity() : null);
              if (productEntity != null) {
                return ProductDetailsView(
                  product: productEntity,
                  initialFlavor: extra['selectedFlavor'] as String?,
                  initialSize: extra['selectedSize'] as String?,
                );
              }
            }
            return Scaffold(
              body: Center(
                child: Text(
                  AppLocalizations.of(context)?.productDataMissing ??
                      'Product data missing',
                ),
              ),
            );
          },
        ),
      ];
}
