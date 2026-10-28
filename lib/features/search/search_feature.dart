/// Public contracts and interfaces for the Search Feature.
/// External features must ONLY import this barrel file to interact with Search.
library;

// Domain Entities
export 'domain/entities/price_bounds.dart';

// Domain Repositories & UseCases
export 'domain/repositories/search_repository.dart';
export 'domain/usecases/search_products_usecase.dart';
export 'domain/usecases/filter_by_price_usecase.dart';
export 'domain/usecases/calculate_price_bounds_usecase.dart';
export 'domain/usecases/get_search_history_usecase.dart';
export 'domain/usecases/add_search_term_usecase.dart';
export 'domain/usecases/remove_search_term_usecase.dart';
export 'domain/usecases/clear_search_history_usecase.dart';

// Scoped Dependency Injection
export 'search_providers.dart';

// Modular Routing
export 'search_routes.dart';

// Presentation Controllers
export 'presentation/controllers/product_search_controller.dart';
export 'presentation/controllers/search_history_controller.dart';

// Presentation Pages & Widgets
export 'presentation/pages/search_page.dart';
export 'presentation/widgets/search_bar.dart';
export 'presentation/widgets/search_bar_inline.dart';
export 'presentation/widgets/search_input_group.dart';
export 'presentation/widgets/product_search_autocomplete.dart';
