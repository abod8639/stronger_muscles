import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';
import 'package:stronger_muscles/features/order/data/mappers/order_mapper.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/presentation/pages/order_details_view.dart';
import 'package:stronger_muscles/features/order/presentation/pages/order_view.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Dedicated modular routing configuration for Orders feature.
class OrderRoutes {
  const OrderRoutes._();

  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.orderView,
      builder: (context, state) => const OrderView(),
    ),
    GoRoute(
      path: AppRoutes.orderDetails,
      builder: (context, state) {
        final extra = state.extra;
        final OrderEntity? order = extra is OrderEntity
            ? extra
            : (extra is OrderModel ? extra.toEntity() : null);

        if (order != null) {
          return OrderDetailsView(order: order);
        }

        return const OrderView();
      },
    ),
  ];
}
