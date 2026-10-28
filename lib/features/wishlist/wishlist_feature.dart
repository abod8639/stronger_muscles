/// Public barrel file for the Wishlist feature.
/// Exposes strictly public contracts, use cases, providers, routes, and views.
/// Internal data sources, DTOs, and private widgets remain encapsulated.
library;

// Domain Entities
export 'domain/entities/wishlist_item_entity.dart';

// Domain Repositories
export 'domain/repositories/wishlist_repository.dart';

// Domain UseCases
export 'domain/usecases/add_to_wishlist_usecase.dart';
export 'domain/usecases/get_wishlist_usecase.dart';
export 'domain/usecases/is_in_wishlist_usecase.dart';
export 'domain/usecases/remove_from_wishlist_usecase.dart';

// Scoped Dependency Injection Providers
export 'wishlist_providers.dart';

// Presentation Controller
export 'presentation/controllers/wishlist_controller.dart'
    show wishlistControllerProvider, WishlistController;

// Presentation Page
export 'presentation/pages/wishlist_view.dart';

// Modular Routing
export 'wishlist_routes.dart';
