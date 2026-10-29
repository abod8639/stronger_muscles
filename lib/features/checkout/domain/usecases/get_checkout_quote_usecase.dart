import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import '../entities/checkout_params.dart';
import '../entities/checkout_quote.dart';
import '../repositories/checkout_repository.dart';

/// Pure Dart UseCase to price the cart (delivery fee, tax, total) before ordering.
class GetCheckoutQuoteUseCase {
  const GetCheckoutQuoteUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Either<Failure, CheckoutQuote>> call(List<CheckoutItemEntity> items) {
    return _repository.getQuote(items);
  }
}
