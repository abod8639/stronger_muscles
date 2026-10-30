import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/promo/data/datasources/promo_local_datasource.dart';
import 'package:stronger_muscles/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';
import 'package:stronger_muscles/features/promo/data/repositories/promo_repository_impl.dart';

class FakePromoRemoteDataSource implements PromoRemoteDataSource {
  final List<PromoModel> modelsToReturn;
  final Exception? exceptionToThrow;

  FakePromoRemoteDataSource({
    this.modelsToReturn = const [],
    this.exceptionToThrow,
  });

  @override
  Future<List<PromoModel>> getPromos() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return modelsToReturn;
  }
}

class FakePromoLocalDataSource implements PromoLocalDataSource {
  List<PromoModel> cached = [];

  @override
  List<PromoModel> getCachedPromos() => List.from(cached);

  @override
  Future<void> cachePromos(List<PromoModel> promos) async {
    cached = List.from(promos);
  }

  @override
  Future<void> clearCache() async {
    cached.clear();
  }
}

void main() {
  group('PromoRepositoryImpl Tests', () {
    const sampleModels = [
      PromoModel(
        id: 1,
        title: 'Offer 1',
        subtitle: 'Discount',
        imageUrl: 'https://example.com/1.jpg',
        buttonText: 'Buy',
        hexBackgroundColor: '#FF0000',
        targetType: 'product',
        targetId: 'prod_1',
      ),
      PromoModel(
        id: 2,
        imageUrl: 'https://example.com/2.jpg',
        buttonText: 'Check',
        hexBackgroundColor: '#00FF00',
        targetType: 'none',
      ),
    ];

    test('getPromos fetches from remote data source and caches locally on success', () async {
      final fakeRemote = FakePromoRemoteDataSource(modelsToReturn: sampleModels);
      final fakeLocal = FakePromoLocalDataSource();
      final repository = PromoRepositoryImpl(fakeRemote, fakeLocal);

      final result = await repository.getPromos();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (entities) {
          expect(entities.length, 2);
          expect(entities[0].id, 1);
          expect(entities[0].title, 'Offer 1');
          expect(entities[0].subtitle, 'Discount');
          expect(entities[0].imageUrl, 'https://example.com/1.jpg');
          expect(entities[0].buttonText, 'Buy');
          expect(entities[0].hexBackgroundColor, '#FF0000');
          expect(entities[0].targetType, 'product');
          expect(entities[0].targetId, 'prod_1');

          expect(entities[1].id, 2);
          expect(entities[1].title, isNull);
          expect(entities[1].targetType, 'none');
        },
      );

      expect(fakeLocal.cached.length, 2);
    });

    test('getPromos falls back to cached promos when remote fails', () async {
      final fakeRemote = FakePromoRemoteDataSource(
        exceptionToThrow: Exception('Server error'),
      );
      final fakeLocal = FakePromoLocalDataSource()..cached = List.from(sampleModels);
      final repository = PromoRepositoryImpl(fakeRemote, fakeLocal);

      final result = await repository.getPromos();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (entities) {
          expect(entities.length, 2);
          expect(entities[0].id, 1);
        },
      );
    });

    test('getPromos returns Failure when remote fails and no cache exists', () async {
      final fakeRemote = FakePromoRemoteDataSource(
        exceptionToThrow: Exception('Server error'),
      );
      final fakeLocal = FakePromoLocalDataSource();
      final repository = PromoRepositoryImpl(fakeRemote, fakeLocal);

      final result = await repository.getPromos();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}
