import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Pure domain repository contract defining product operations with functional error handling.
abstract class ProductRepository {
  /// Returns cached products synchronously if available.
  Either<Failure, List<ProductEntity>> getCachedProducts();

  /// Fetches products from remote API (with pagination and optional category filter).
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
  });

  /// Fetches a single product by ID (cache-first or remote).
  Future<Either<Failure, ProductEntity>> getProductById(String id);

  /// Searches products matching a text query.
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
}
