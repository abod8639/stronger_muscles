import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/wishlist/data/datasources/wishlist_local_datasource.dart';
import 'package:stronger_muscles/features/wishlist/data/datasources/wishlist_remote_datasource.dart';
import 'package:stronger_muscles/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/is_in_wishlist_usecase.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';

// --- DataSources ---

final wishlistLocalDataSourceProvider = Provider<WishlistLocalDataSource>((ref) {
  Box<String>? box;
  try {
    if (Hive.isBoxOpen('wishlist')) {
      box = Hive.box<String>('wishlist');
    }
  } catch (_) {
    box = null;
  }
  return WishlistLocalDataSourceImpl(box);
});

final wishlistRemoteDataSourceProvider = Provider<WishlistRemoteDataSource>((ref) {
  return WishlistRemoteDataSourceImpl(ref.watch(apiServiceProvider));
});

// --- Repository (Single Source of Truth) ---

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepositoryImpl(
    ref.watch(wishlistLocalDataSourceProvider),
    ref.watch(wishlistRemoteDataSourceProvider),
  );
});

// --- UseCases ---

final getWishlistUseCaseProvider = Provider<GetWishlistUseCase>((ref) {
  return GetWishlistUseCase(ref.watch(wishlistRepositoryProvider));
});

final addToWishlistUseCaseProvider = Provider<AddToWishlistUseCase>((ref) {
  return AddToWishlistUseCase(ref.watch(wishlistRepositoryProvider));
});

final removeFromWishlistUseCaseProvider = Provider<RemoveFromWishlistUseCase>((ref) {
  return RemoveFromWishlistUseCase(ref.watch(wishlistRepositoryProvider));
});

final isInWishlistUseCaseProvider = Provider<IsInWishlistUseCase>((ref) {
  return IsInWishlistUseCase(ref.watch(wishlistRepositoryProvider));
});
