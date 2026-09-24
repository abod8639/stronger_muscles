import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  const sampleProduct1 = ProductModel(
    id: 'prod-101',
    name: LocalizedString(en: 'Whey Isolate', ar: 'واي أيزوليت'),
    price: 300.0,
  );

  const sampleProduct2 = ProductModel(
    id: 'prod-102',
    name: LocalizedString(en: 'Creatine Monohydrate', ar: 'كرياتين مونوهيدرات'),
    price: 120.0,
  );

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('wishlist_service_test_');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    if (!Hive.isBoxOpen('wishlist')) {
      await Hive.openBox<String>('wishlist');
    } else {
      await Hive.box<String>('wishlist').clear();
    }
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('WishlistService Tests', () {
    test('initial state is empty when wishlist box has no entries', () {
      final items = container.read(wishlistServiceProvider);
      expect(items, isEmpty);
      expect(container.read(wishlistServiceProvider.notifier).isFavorite('prod-101'), isFalse);
    });

    test('toggleFavorite adds product to wishlist and updates state and Hive storage', () {
      final notifier = container.read(wishlistServiceProvider.notifier);

      notifier.toggleFavorite(sampleProduct1);

      final state = container.read(wishlistServiceProvider);
      expect(state.length, 1);
      expect(state.first.id, 'prod-101');
      expect(notifier.isFavorite('prod-101'), isTrue);
      expect(Hive.box<String>('wishlist').containsKey('prod-101'), isTrue);
    });

    test('toggleFavorite removes product when toggled second time', () {
      final notifier = container.read(wishlistServiceProvider.notifier);

      // Add product 1 and product 2
      notifier.toggleFavorite(sampleProduct1);
      notifier.toggleFavorite(sampleProduct2);
      expect(container.read(wishlistServiceProvider).length, 2);

      // Toggle product 1 off
      notifier.toggleFavorite(sampleProduct1);

      final updatedState = container.read(wishlistServiceProvider);
      expect(updatedState.length, 1);
      expect(updatedState.first.id, 'prod-102');
      expect(notifier.isFavorite('prod-101'), isFalse);
      expect(notifier.isFavorite('prod-102'), isTrue);
      expect(Hive.box<String>('wishlist').containsKey('prod-101'), isFalse);
    });

    test('build loads previously persisted items and ignores corrupt JSON gracefully', () async {
      final box = Hive.box<String>('wishlist');
      await box.put(sampleProduct1.id, '{"id":"prod-101","name":{"en":"Whey Isolate","ar":"واي أيزوليت"},"price":300.0}');
      await box.put('corrupt-key', 'INVALID_JSON_CONTENT{{{');

      // Create new container to trigger build()
      final freshContainer = ProviderContainer();
      addTearDown(freshContainer.dispose);

      final loaded = freshContainer.read(wishlistServiceProvider);
      expect(loaded.length, 1);
      expect(loaded.first.id, 'prod-101');
    });
  });
}
