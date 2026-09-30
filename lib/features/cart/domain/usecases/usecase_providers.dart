import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/cart/data/repositories/cart_repository.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/update_cart_quantity_usecase.dart';

part 'usecase_providers.g.dart';

@riverpod
GetCartItemsUseCase getCartItemsUseCase(GetCartItemsUseCaseRef ref) {
  final CartRepository repository = ref.watch(cartRepositoryProvider);
  return GetCartItemsUseCase(repository);
}

@riverpod
AddToCartUseCase addToCartUseCase(AddToCartUseCaseRef ref) {
  final CartRepository repository = ref.watch(cartRepositoryProvider);
  return AddToCartUseCase(repository);
}

@riverpod
RemoveFromCartUseCase removeFromCartUseCase(RemoveFromCartUseCaseRef ref) {
  final CartRepository repository = ref.watch(cartRepositoryProvider);
  return RemoveFromCartUseCase(repository);
}

@riverpod
UpdateCartQuantityUseCase updateCartQuantityUseCase(
  UpdateCartQuantityUseCaseRef ref,
) {
  final CartRepository repository = ref.watch(cartRepositoryProvider);
  return UpdateCartQuantityUseCase(repository);
}

@riverpod
ClearCartUseCase clearCartUseCase(ClearCartUseCaseRef ref) {
  final CartRepository repository = ref.watch(cartRepositoryProvider);
  return ClearCartUseCase(repository);
}
