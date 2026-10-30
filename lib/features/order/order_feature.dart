/// Public contracts and interfaces for the Order Feature.
///
/// External features must ONLY import this barrel file to interact with Order.
/// Internal DataSources, DTOs, and private implementations remain encapsulated.
library;

// Domain Entities & Repositories
export 'domain/entities/order_entity.dart';
export 'domain/entities/order_item_entity.dart';
export 'domain/repositories/order_repository.dart';
export 'data/models/order_model.dart';

// Domain UseCases
export 'domain/usecases/get_user_orders_usecase.dart';
export 'domain/usecases/get_order_by_id_usecase.dart';
export 'domain/usecases/create_order_usecase.dart';
export 'domain/usecases/cancel_order_usecase.dart';

// Scoped Dependency Injection Providers
export 'order_providers.dart';

// Modular Routing
export 'order_routes.dart';

// Presentation State & Controllers
export 'presentation/controllers/orders_controller.dart'
    show
        ordersControllerProvider,
        orderRepositoryProvider,
        OrdersController;

// Presentation Views & Widgets
export 'presentation/pages/order_view.dart';
export 'presentation/pages/order_details_view.dart';
export 'presentation/widgets/order_card.dart';
export 'presentation/widgets/order_status_tracker.dart';
export 'presentation/utils/order_status_ui.dart';
