import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';

/// Domain contract for processing checkout orders and payments.
abstract class CheckoutRepository {
  Future<Map<String, dynamic>> placeOrder(CheckoutParams params);
}
