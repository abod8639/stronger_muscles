/// Public contracts and interfaces for the Product Feature.
/// External features must ONLY import this barrel file to interact with Product.
library;

// Domain Entities
export 'domain/entities/product_entity.dart';
export 'domain/entities/category_entity.dart';
export 'domain/entities/image_url_entity.dart';
export 'domain/entities/localized_string_entity.dart';
export 'domain/entities/product_category_entity.dart';
export 'domain/entities/product_size_entity.dart';

// Data Models (for data layer / caching adapters)
export 'data/models/product_model.dart';
export 'data/models/category_model.dart';
