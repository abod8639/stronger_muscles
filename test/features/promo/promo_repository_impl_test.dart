import 'package:flutter_test/flutter_test.dart';
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

void main() {
  group('PromoRepositoryImpl Tests', () {
    test('getPromos converts models from remote data source into domain entities', () async {
      final sampleModels = [
        const PromoModel(
          id: 1,
          title: 'Offer 1',
          subtitle: 'Discount',
          imageUrl: 'https://example.com/1.jpg',
          buttonText: 'Buy',
          hexBackgroundColor: '#FF0000',
          targetType: 'product',
          targetId: 'prod_1',
        ),
        const PromoModel(
          id: 2,
          imageUrl: 'https://example.com/2.jpg',
          buttonText: 'Shop',
          hexBackgroundColor: '#00FF00',
          targetType: 'none',
        ),
      ];

      final fakeDataSource = FakePromoRemoteDataSource(modelsToReturn: sampleModels);
      final repository = PromoRepositoryImpl(fakeDataSource);

      final entities = await repository.getPromos();

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
    });

    test('propagates exception when remote data source fails', () async {
      final fakeDataSource = FakePromoRemoteDataSource(
        exceptionToThrow: Exception('Server error'),
      );
      final repository = PromoRepositoryImpl(fakeDataSource);

      expect(() => repository.getPromos(), throwsA(isA<Exception>()));
    });
  });
}
