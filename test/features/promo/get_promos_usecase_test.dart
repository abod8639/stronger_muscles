import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';
import 'package:stronger_muscles/features/promo/domain/repositories/promo_repository.dart';
import 'package:stronger_muscles/features/promo/domain/usecases/get_promos_usecase.dart';

class FakePromoRepository implements PromoRepository {
  final List<PromoEntity> promosToReturn;
  final Failure? failure;

  FakePromoRepository({
    this.promosToReturn = const [],
    this.failure,
  });

  @override
  Future<Either<Failure, List<PromoEntity>>> getPromos() async {
    if (failure != null) {
      return Left(failure!);
    }
    return Right(promosToReturn);
  }
}

void main() {
  group('GetPromosUseCase Tests', () {
    test('calls repository.getPromos and returns promo entities on success', () async {
      const samplePromos = [
        PromoEntity(
          id: 1,
          title: 'Mega Deal',
          imageUrl: 'https://example.com/banner.jpg',
        ),
        PromoEntity(
          id: 2,
          title: 'Summer Offer',
          imageUrl: 'https://example.com/banner2.jpg',
        ),
      ];

      final fakeRepository = FakePromoRepository(promosToReturn: samplePromos);
      final useCase = GetPromosUseCase(fakeRepository);

      final result = await useCase.call();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (promos) {
          expect(promos, equals(samplePromos));
          expect(promos.length, 2);
          expect(promos.first.id, 1);
        },
      );
    });

    test('propagates failure when repository fails', () async {
      final fakeRepository = FakePromoRepository(
        failure: const Failure(message: 'Network failure', type: FailureType.network),
      );
      final useCase = GetPromosUseCase(fakeRepository);

      final result = await useCase.call();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'Network failure'),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}
