import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';
import 'package:stronger_muscles/features/checkout/domain/repositories/checkout_repository.dart';

/// Use case to submit an order and initiate payment if needed.
class PlaceOrderUseCase {
  final CheckoutRepository _repository;

  const PlaceOrderUseCase(this._repository);

  Future<Map<String, dynamic>> call(CheckoutParams params) {
    return _repository.placeOrder(params);
  }
}
