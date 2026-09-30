import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';
import 'package:stronger_muscles/features/promo/domain/repositories/promo_repository.dart';
import 'package:stronger_muscles/features/promo/domain/usecases/get_promos_usecase.dart';

class FakePromoRepository implements PromoRepository {
  final List<PromoEntity> promosToReturn;
  final Exception? exceptionToThrow;

  FakePromoRepository({
    this.promosToReturn = const [],
    this.exceptionToThrow,
  });

  @override
  Future<List<PromoEntity>> getPromos() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return promosToReturn;
  }
}

void main() {
  group('GetPromosUseCase Tests', () {
    test('calls repository.getPromos and returns promo entities', () async {
      final samplePromos = [
        const PromoEntity(
          id: 1,
          title: 'Mega Deal',
          imageUrl: 'https://example.com/banner.jpg',
        ),
        const PromoEntity(
          id: 2,
          title: 'Summer Offer',
          imageUrl: 'https://example.com/banner2.jpg',
        ),
      ];

      final fakeRepository = FakePromoRepository(promosToReturn: samplePromos);
      final useCase = GetPromosUseCase(fakeRepository);

      final result = await useCase.call();

      expect(result, equals(samplePromos));
      expect(result.length, 2);
      expect(result.first.id, 1);
    });

    test('propagates exception when repository fails', () async {
      final fakeRepository = FakePromoRepository(
        exceptionToThrow: Exception('Network failure'),
      );
      final useCase = GetPromosUseCase(fakeRepository);

      expect(() => useCase.call(), throwsA(isA<Exception>()));
    });
  });
}
