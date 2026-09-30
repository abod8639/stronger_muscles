import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';
import 'package:stronger_muscles/features/promo/domain/repositories/promo_repository.dart';

/// Clean Architecture UseCase to retrieve the list of active promos.
class GetPromosUseCase {
  final PromoRepository _repository;

  const GetPromosUseCase(this._repository);

  Future<List<PromoEntity>> call() {
    return _repository.getPromos();
  }
}
