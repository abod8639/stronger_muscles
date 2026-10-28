/// Public API barrel file for the Cart feature module.
/// Strictly encapsulates internal data sources, models, mappers, and internal card widgets,
/// exposing only public domain entities, repository contracts, use cases, providers,
/// routes, and top-level public UI entry points.
library;

// ── Domain Layer (Contracts & Entities) ──────────────────────────────────────
export 'domain/entities/cart_item_entity.dart';
export 'domain/repositories/cart_repository.dart';
export 'domain/usecases/add_to_cart_usecase.dart';
export 'domain/usecases/clear_cart_usecase.dart';
export 'domain/usecases/get_cart_items_usecase.dart';
export 'domain/usecases/remove_from_cart_usecase.dart';
export 'domain/usecases/update_cart_quantity_usecase.dart';

// ── Presentation Layer (Controllers & Scoped DI) ─────────────────────────────
export 'presentation/controllers/cart_controller.dart';
export 'presentation/controllers/cart_di.dart';

// ── Public UI Components & Routing ───────────────────────────────────────────
export 'cart_routes.dart';
export 'presentation/pages/cart_view.dart';
export 'presentation/widgets/cart_icon.dart';
