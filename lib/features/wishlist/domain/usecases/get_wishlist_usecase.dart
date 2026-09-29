import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

class GetWishlistUseCase {
  final WishlistRepository repository;

  GetWishlistUseCase(this.repository);

  List<ProductModel> call() {
    return repository.getWishlistItems();
  }
}
