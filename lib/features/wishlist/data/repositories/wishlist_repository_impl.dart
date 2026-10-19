import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/wishlist/data/datasources/wishlist_local_datasource.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

part 'wishlist_repository_impl.g.dart';

@Riverpod(keepAlive: true)
WishlistRepository wishlistRepository(WishlistRepositoryRef ref) {
  final box = Hive.box<String>('wishlist');
  return WishlistRepositoryImpl(WishlistLocalDatasource(box));
}

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDatasource _datasource;

  WishlistRepositoryImpl(this._datasource);

  @override
  List<ProductEntity> getWishlistItems() {
    return _datasource.getAll().map((m) => m.toEntity()).toList();
  }

  @override
  void addToWishlist(ProductEntity product) {
    _datasource.add(ProductModel.fromEntity(product));
  }

  @override
  void removeFromWishlist(ProductEntity product) {
    _datasource.remove(product.id);
  }

  @override
  bool isInWishlist(String productId) {
    return _datasource.contains(productId);
  }
}

