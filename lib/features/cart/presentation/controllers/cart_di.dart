import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:stronger_muscles/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/update_cart_quantity_usecase.dart';

// ── Data Sources ─────────────────────────────────────────────────────────────

final cartLocalDataSourceProvider = Provider<CartLocalDataSource>((ref) {
  final box = Hive.isBoxOpen(CartLocalDataSourceImpl.boxName)
      ? Hive.box<CartItemModel>(CartLocalDataSourceImpl.boxName)
      : null;
  return CartLocalDataSourceImpl(box);
});

final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CartRemoteDataSourceImpl(apiService);
});

// ── Repository ───────────────────────────────────────────────────────────────

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final localDataSource = ref.watch(cartLocalDataSourceProvider);
  final remoteDataSource = ref.watch(cartRemoteDataSourceProvider);

  return CartRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    getUserId: () {
      final authState = ref.read(authControllerProvider);
      return authState.valueOrNull?.id.toString() ?? '';
    },
  );
});

// ── Use Cases ────────────────────────────────────────────────────────────────

final getCartItemsUseCaseProvider = Provider<GetCartItemsUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return GetCartItemsUseCase(repository);
});

final addToCartUseCaseProvider = Provider<AddToCartUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return AddToCartUseCase(repository);
});

final removeFromCartUseCaseProvider = Provider<RemoveFromCartUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return RemoveFromCartUseCase(repository);
});

final updateCartQuantityUseCaseProvider =
    Provider<UpdateCartQuantityUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return UpdateCartQuantityUseCase(repository);
});

final clearCartUseCaseProvider = Provider<ClearCartUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return ClearCartUseCase(repository);
});
