import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

export 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';
export 'package:stronger_muscles/features/cart/data/repositories/cart_repository_impl.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final box = Hive.isBoxOpen(CartLocalDataSourceImpl.boxName)
      ? Hive.box<CartItemModel>(CartLocalDataSourceImpl.boxName)
      : throw StateError(
          'Hive box "${CartLocalDataSourceImpl.boxName}" must be opened before accessing CartRepository',
        );

  return CartRepositoryImpl(
    localDataSource: CartLocalDataSourceImpl(box),
    getUserId: () {
      final auth = ref.read(authControllerProvider.notifier);
      return auth.currentUser?.id.toString() ?? '';
    },
  );
});
