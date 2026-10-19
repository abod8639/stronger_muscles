import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/is_in_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';

class FakeWishlistRepository implements WishlistRepository {
  final List<ProductEntity> items = [];

  @override
  List<ProductEntity> getWishlistItems() => List.unmodifiable(items);

  @override
  void addToWishlist(ProductEntity product) {
    if (!items.any((p) => p.id == product.id)) {
      items.add(product);
    }
  }

  @override
  void removeFromWishlist(ProductEntity product) {
    items.removeWhere((p) => p.id == product.id);
  }

  @override
  bool isInWishlist(String productId) {
    return items.any((p) => p.id == productId);
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
    test('GetWishlistUseCase returns items from repository', () {
      repository.items.add(testProduct);

      final result = getWishlistUseCase();

      expect(result, [testProduct]);
    });

    test('AddToWishlistUseCase adds product to repository', () {
      addToWishlistUseCase(testProduct);

      expect(repository.items, contains(testProduct));
    });

    test('RemoveFromWishlistUseCase removes product from repository', () {
      repository.items.add(testProduct);

      removeFromWishlistUseCase(testProduct);

      expect(repository.items, isEmpty);
    });

    test('IsInWishlistUseCase returns true when product is in wishlist', () {
      repository.items.add(testProduct);

      final result = isInWishlistUseCase('prod-101');

      expect(result, isTrue);
    });

    test('IsInWishlistUseCase returns false when product is not in wishlist', () {
      final result = isInWishlistUseCase('prod-999');

      expect(result, isFalse);
    });
  });
}
