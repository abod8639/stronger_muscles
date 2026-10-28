/// Public contracts and interfaces for the Product Feature.
/// External features must ONLY import this barrel file to interact with Product.
library;

// Domain Entities
export 'domain/entities/category_entity.dart';
export 'domain/entities/image_url_entity.dart';
export 'domain/entities/localized_string_entity.dart';
export 'domain/entities/product_category_entity.dart';
export 'domain/entities/product_entity.dart';
export 'domain/entities/product_size_entity.dart';
export 'domain/entities/review_entity.dart';

// Domain Repositories
export 'domain/repositories/category_repository.dart';
export 'domain/repositories/product_repository.dart';
export 'domain/repositories/review_repository.dart';

// Domain UseCases
export 'domain/usecases/get_all_categories_usecase.dart';
export 'domain/usecases/get_cached_categories_usecase.dart';
export 'domain/usecases/get_cached_products_usecase.dart';
export 'domain/usecases/get_product_by_id_usecase.dart';
export 'domain/usecases/get_products_usecase.dart';
export 'domain/usecases/review_usecases.dart';
export 'domain/usecases/search_products_usecase.dart';

// Data Mappers (for Entity <-> Model conversion)
export 'data/mappers/product_mapper.dart';

// Data Models (for adapters / cross-feature DTO usage)
export 'data/models/category_model.dart';
export 'data/models/image_url_model.dart';
export 'data/models/product_category_model.dart';
export 'data/models/product_model.dart';
export 'data/models/product_size_model.dart';
export 'data/models/review_model.dart';

// Scoped DI Providers
export 'product_providers.dart';

// Presentation State & Controllers
export 'presentation/controllers/category_controller.dart'
    show categoryControllerProvider, CategoryController;
export 'presentation/controllers/products_controller.dart'
    show productsControllerProvider, ProductsController;
export 'presentation/controllers/products_state.dart';

// Public UI
export 'presentation/pages/product_catalog_view.dart';
export 'presentation/widgets/category_chip_selector.dart';

// Modular Routes
export 'product_routes.dart';
