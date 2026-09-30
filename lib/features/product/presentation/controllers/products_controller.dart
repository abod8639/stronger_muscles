import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/usecases/usecase_providers.dart';

part 'products_controller.g.dart';

@riverpod
class ProductsController extends _$ProductsController {
  String _selectedCategoryId = '';
  String get selectedCategoryId => _selectedCategoryId;

  @override
  FutureOr<List<ProductEntity>> build() async {
    final cached = ref.watch(getCachedProductsUseCaseProvider)();

    if (cached.isNotEmpty) {
      return cached;
    }

    return await ref.watch(getProductsUseCaseProvider)();
  }

  Future<void> fetchProducts({String? categoryId, String? query}) async {
    state = const AsyncLoading();
    try {
      List<ProductEntity> result;
      if (query != null && query.trim().isNotEmpty) {
        result = await ref.read(searchProductsUseCaseProvider)(query);
      } else {
        result = await ref.read(getProductsUseCaseProvider)(
          categoryId:
              categoryId ??
              (_selectedCategoryId.isEmpty ? null : _selectedCategoryId),
        );
      }
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void filterByCategory(String categoryId) {
    _selectedCategoryId = (_selectedCategoryId == categoryId) ? '' : categoryId;
    fetchProducts(
      categoryId: _selectedCategoryId.isEmpty ? null : _selectedCategoryId,
    );
  }
}
