import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';

part 'products_controller.g.dart';

@riverpod
class ProductsController extends _$ProductsController {
  String _selectedCategoryId = '';
  String get selectedCategoryId => _selectedCategoryId;

  @override
  FutureOr<List<ProductModel>> build() async {
    final repository = ref.watch(productRepositoryProvider.notifier);
    final cached = repository.getCachedProducts();

    if (cached.isNotEmpty) {
      _initFetch();
      return cached;
    }

    return await repository.getProducts();
  }

  Future<void> _initFetch() async {
    await fetchProducts();
  }

  Future<void> fetchProducts({String? categoryId, String? query}) async {
    state = const AsyncLoading();
    final repository = ref.read(productRepositoryProvider.notifier);
    try {
      List<ProductModel> result;
      if (query != null && query.trim().isNotEmpty) {
        result = await repository.searchProducts(query);
      } else {
        result = await repository.getProducts(
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
