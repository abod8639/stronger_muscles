/// Public contracts and interfaces for the Home Feature.
///
/// External features must ONLY import this barrel file to interact with Home.
/// Internal DataSources, DTOs, and private implementations remain encapsulated.
library;

// Domain Entities & Repositories
export 'domain/entities/selection_entity.dart';
export 'domain/repositories/home_repository.dart';

// Domain UseCases
export 'domain/usecases/get_home_shortcuts_usecase.dart';
export 'domain/usecases/get_home_products_usecase.dart';

// Scoped Dependency Injection Providers
export 'home_providers.dart';

// Modular Routing
export 'home_routes.dart';

// Presentation Pages & Views
export 'presentation/pages/home_view.dart';

// Presentation Helpers
export 'presentation/helpers/selection_ui_mapper.dart';

// App shell navigation
export 'presentation/widgets/main_bottom_nav_bar.dart';
