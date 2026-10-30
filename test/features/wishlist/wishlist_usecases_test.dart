import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/is_in_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';

class FakeWishlistRepository implements WishlistRepository {
  final List<ProductEntity> items = [];
  Failure? failure;

  @override
  Future<Either<Failure, List<ProductEntity>>> getWishlistItems() async {
    if (failure != null) return Left(failure!);
    return Right(List.unmodifiable(items));
  }

  @override
  Either<Failure, List<ProductEntity>> getCachedWishlist() {
    if (failure != null) return Left(failure!);
    return Right(List.unmodifiable(items));
  }

  @override
  Future<Either<Failure, Unit>> addToWishlist(ProductEntity product) async {
    if (failure != null) return Left(failure!);
    if (!items.any((p) => p.id == product.id)) {
      items.add(product);
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> removeFromWishlist(ProductEntity product) async {
    if (failure != null) return Left(failure!);
    items.removeWhere((p) => p.id == product.id);
    return const Right(unit);
  }

  @override
  Either<Failure, bool> isInWishlist(String productId) {
    if (failure != null) return Left(failure!);
    return Right(items.any((p) => p.id == productId));
  }
}

void main() {
  late FakeWishlistRepository repository;
  late GetWishlistUseCase getWishlistUseCase;
  late AddToWishlistUseCase addToWishlistUseCase;
  late RemoveFromWishlistUseCase removeFromWishlistUseCase;
  late IsInWishlistUseCase isInWishlistUseCase;

  const testProduct = ProductEntity(
    id: 'prod-101',
    price: 450.0,
    stockQuantity: 10,
  );

  setUp(() {
    repository = FakeWishlistRepository();
    getWishlistUseCase = GetWishlistUseCase(repository);
    addToWishlistUseCase = AddToWishlistUseCase(repository);
    removeFromWishlistUseCase = RemoveFromWishlistUseCase(repository);
    isInWishlistUseCase = IsInWishlistUseCase(repository);
  });

  group('WishlistItemEntity Tests', () {
    final fixedDate = DateTime(2025, 1, 1);
    final entity1 = WishlistItemEntity(
      id: 'item-1',
      userId: 'user-1',
      productId: 'prod-1',
      addedAt: fixedDate,
      productName: 'Protein',
      productPrice: 200.0,
      productImageUrl: 'https://example.com/p.png',
    );

    test('value equality and hashCode', () {
      final entity2 = WishlistItemEntity(
        id: 'item-1',
        userId: 'user-1',
        productId: 'prod-1',
        addedAt: fixedDate,
        productName: 'Protein',
        productPrice: 200.0,
        productImageUrl: 'https://example.com/p.png',
      );

      expect(entity1, equals(entity2));
      expect(entity1.hashCode, equals(entity2.hashCode));
    });

    test('copyWith works properly', () {
      final updated = entity1.copyWith(productPrice: 220.0);
      expect(updated.productPrice, 220.0);
      expect(updated.id, 'item-1');
      expect(updated.productName, 'Protein');
    });
  });

  group('Wishlist UseCases Tests', () {
    test('GetWishlistUseCase returns items from repository', () async {
      repository.items.add(testProduct);

      final result = await getWishlistUseCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (items) => expect(items, [testProduct]),
      );
    });

    test('GetWishlistUseCase getCached returns cached items', () {
      repository.items.add(testProduct);

      final result = getWishlistUseCase.getCached();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (items) => expect(items, [testProduct]),
      );
    });

    test('AddToWishlistUseCase adds product to repository', () async {
      final result = await addToWishlistUseCase(testProduct);

      expect(result.isRight(), isTrue);
      expect(repository.items, contains(testProduct));
    });

    test('AddToWishlistUseCase does not duplicate product when already added', () async {
      repository.items.add(testProduct);

      final result = await addToWishlistUseCase(testProduct);

      expect(result.isRight(), isTrue);
      expect(repository.items.length, 1);
    });

    test('RemoveFromWishlistUseCase removes product from repository', () async {
      repository.items.add(testProduct);

      final result = await removeFromWishlistUseCase(testProduct);

      expect(result.isRight(), isTrue);
      expect(repository.items, isEmpty);
    });

    test('IsInWishlistUseCase returns true when product is in wishlist', () {
      repository.items.add(testProduct);

      final result = isInWishlistUseCase('prod-101');

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => false), isTrue);
    });

    test('IsInWishlistUseCase returns false when product is not in wishlist', () {
      final result = isInWishlistUseCase('prod-999');

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => true), isFalse);
    });
  });
}
