import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/is_in_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';

part 'usecase_providers.g.dart';

@riverpod
GetWishlistUseCase getWishlistUseCase(GetWishlistUseCaseRef ref) {
  final WishlistRepository repository = ref.watch(wishlistRepositoryProvider);
  return GetWishlistUseCase(repository);
}

@riverpod
AddToWishlistUseCase addToWishlistUseCase(AddToWishlistUseCaseRef ref) {
  final WishlistRepository repository = ref.watch(wishlistRepositoryProvider);
  return AddToWishlistUseCase(repository);
}

@riverpod
RemoveFromWishlistUseCase removeFromWishlistUseCase(
  RemoveFromWishlistUseCaseRef ref,
) {
  final WishlistRepository repository = ref.watch(wishlistRepositoryProvider);
  return RemoveFromWishlistUseCase(repository);
}

@riverpod
IsInWishlistUseCase isInWishlistUseCase(IsInWishlistUseCaseRef ref) {
  final WishlistRepository repository = ref.watch(wishlistRepositoryProvider);
  return IsInWishlistUseCase(repository);
}
