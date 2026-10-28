import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';

/// Pure domain contract for Promo repository.
abstract class PromoRepository {
  /// Fetches active promotional items wrapped in [Either].
  Future<Either<Failure, List<PromoEntity>>> getPromos();
}
