/// Public contracts and interfaces for the Promo Feature.
/// External features must ONLY import this barrel file to interact with Promo.
library;

// Domain Entities
export 'domain/entities/promo_entity.dart';

// Domain Repositories & UseCases
export 'domain/repositories/promo_repository.dart';
export 'domain/usecases/get_promos_usecase.dart';

// Scoped Dependency Injection
export 'promo_providers.dart';

// Modular Routing
export 'promo_routes.dart';

// Presentation Controllers
export 'presentation/controllers/promo_controller.dart';

// Presentation Widgets
export 'presentation/widgets/promo_banner.dart';
export 'presentation/widgets/promo_card.dart';
