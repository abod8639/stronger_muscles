import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:stronger_muscles/features/checkout/domain/usecases/place_order_usecase.dart';

final placeOrderUseCaseProvider = Provider<PlaceOrderUseCase>((ref) {
  final repository = ref.watch(checkoutRepositoryProvider);
  return PlaceOrderUseCase(repository);
});
