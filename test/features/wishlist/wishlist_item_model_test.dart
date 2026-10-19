import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/wishlist/data/models/wishlist_item_model.dart';

void main() {
  group('WishlistItemModel Tests', () {
    final fixedTime = DateTime(2025, 3, 15, 10, 30);

    test('constructor assigns defaults correctly when addedAt is not provided', () {
      final before = DateTime.now().subtract(const Duration(seconds: 1));
      final item = WishlistItemModel(
        id: 'wish-1',
        userId: 'user-1',
        productId: 'prod-1',
      );
      final after = DateTime.now().add(const Duration(seconds: 1));

      expect(item.id, 'wish-1');
      expect(item.userId, 'user-1');
      expect(item.productId, 'prod-1');
      expect(item.addedAt.isAfter(before), isTrue);
      expect(item.addedAt.isBefore(after), isTrue);
    });

    test('fromJson and toJson maintain consistent data', () {
      final json = {
        'id': 'wish-2',
        'userId': 'user-2',
        'productId': 'prod-50',
        'addedAt': fixedTime.toIso8601String(),
        'productName': 'Gold Standard Whey',
        'productPrice': 320.0,
        'productImageUrl': 'https://example.com/whey.png',
      };

      final item = WishlistItemModel.fromJson(json);

      expect(item.id, 'wish-2');
      expect(item.userId, 'user-2');
      expect(item.productId, 'prod-50');
      expect(item.addedAt, fixedTime);
      expect(item.productName, 'Gold Standard Whey');
      expect(item.productPrice, 320.0);
      expect(item.productImageUrl, 'https://example.com/whey.png');

      final serialized = item.toJson();
      expect(serialized['id'], 'wish-2');
      expect(serialized['productPrice'], 320.0);
      expect(serialized['addedAt'], fixedTime.toIso8601String());
    });

    test('copyWith updates specified fields only', () {
      final item = WishlistItemModel(
        id: 'wish-3',
        userId: 'user-3',
        productId: 'prod-3',
        productName: 'Old Name',
        productPrice: 100.0,
        addedAt: fixedTime,
      );

      final updated = item.copyWith(
        productName: 'New Name',
        productPrice: 150.0,
      );

      expect(updated.id, 'wish-3');
      expect(updated.userId, 'user-3');
      expect(updated.productId, 'prod-3');
      expect(updated.addedAt, fixedTime);
      expect(updated.productName, 'New Name');
      expect(updated.productPrice, 150.0);
    });

    test('toEntity converts correctly to WishlistItemEntity', () {
      final model = WishlistItemModel(
        id: 'wish-4',
        userId: 'user-4',
        productId: 'prod-4',
        productName: 'Creatine',
        productPrice: 250.0,
        productImageUrl: 'https://example.com/creatine.png',
        addedAt: fixedTime,
      );

      final entity = model.toEntity();

      expect(entity.id, 'wish-4');
      expect(entity.userId, 'user-4');
      expect(entity.productId, 'prod-4');
      expect(entity.productName, 'Creatine');
      expect(entity.productPrice, 250.0);
      expect(entity.productImageUrl, 'https://example.com/creatine.png');
      expect(entity.addedAt, fixedTime);
    });

    test('fromEntity converts correctly from WishlistItemEntity', () {
      final modelOriginal = WishlistItemModel(
        id: 'wish-5',
        userId: 'user-5',
        productId: 'prod-5',
        productName: 'BCAA',
        productPrice: 180.0,
        productImageUrl: 'https://example.com/bcaa.png',
        addedAt: fixedTime,
      );
      final entity = modelOriginal.toEntity();

      final modelFromEntity = WishlistItemModel.fromEntity(entity);

      expect(modelFromEntity.id, entity.id);
      expect(modelFromEntity.userId, entity.userId);
      expect(modelFromEntity.productId, entity.productId);
      expect(modelFromEntity.productName, entity.productName);
      expect(modelFromEntity.productPrice, entity.productPrice);
      expect(modelFromEntity.productImageUrl, entity.productImageUrl);
      expect(modelFromEntity.addedAt, entity.addedAt);
    });
  });
}

