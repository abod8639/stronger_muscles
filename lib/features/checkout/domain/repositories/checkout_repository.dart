import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import '../entities/checkout_params.dart';
import '../entities/checkout_quote.dart';
import '../entities/checkout_result_entity.dart';

/// Abstract Pure Dart Checkout Repository contract.
///
/// Follows Dependency Inversion Principle (DIP). Returns [Either<Failure, T>]
/// for functional error handling.
abstract class CheckoutRepository {
  Future<Either<Failure, CheckoutResultEntity>> placeOrder(CheckoutParams params);

  /// Prices [items] with the store's current delivery fee and tax rate.
  Future<Either<Failure, CheckoutQuote>> getQuote(List<CheckoutItemEntity> items);
}
