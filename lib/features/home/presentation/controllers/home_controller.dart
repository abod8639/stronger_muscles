import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  int _selectedSectionIndex = 0;
  int get selectedSectionIndex => _selectedSectionIndex;

  @override
  FutureOr<List<ProductModel>> build() async {
    final productRepository = ref.watch(productRepositoryProvider);

    final cachedProducts = productRepository.getCachedProducts();
    if (cachedProducts.isNotEmpty) {
      return cachedProducts;
    }

    return await productRepository.getProducts();
  }

  Future<void> fetchProductsForSection(int index, {String? categoryId}) async {
    _selectedSectionIndex = index;
    state = const AsyncLoading();

    final productRepository = ref.read(productRepositoryProvider);
    try {
      final fetchedProducts = await productRepository.getProducts(
        categoryId: categoryId,
      );
      state = AsyncData(fetchedProducts);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refreshHome() async {
    final index = _selectedSectionIndex;
    final sectionsState = ref.read(categoriesSectionsControllerProvider);

    String? categoryId;
    if (sectionsState.hasValue &&
        index >= 0 &&
        index < sectionsState.value!.length) {
      final id = sectionsState.value![index].id;
      categoryId = id.isEmpty ? null : id;
    }

    await Future.wait([
      fetchProductsForSection(index, categoryId: categoryId),
      ref.read(categoriesSectionsControllerProvider.notifier).fetchCategories(),
    ]);
  }
}
