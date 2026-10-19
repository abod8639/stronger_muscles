import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/home/domain/usecases/usecase_providers.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  int _selectedSectionIndex = 0;
  int get selectedSectionIndex => _selectedSectionIndex;

  @override
  FutureOr<List<ProductModel>> build() async {
    final getHomeProducts = ref.watch(getHomeProductsUseCaseProvider);
    final products = await getHomeProducts();
    return products.map((p) => ProductModel.fromEntity(p)).toList();
  }

  Future<void> fetchProductsForSection(int index, {String? categoryId}) async {
    _selectedSectionIndex = index;
    state = const AsyncLoading();

    final getHomeProducts = ref.read(getHomeProductsUseCaseProvider);
    try {
      final fetchedProducts = await getHomeProducts(categoryId: categoryId);
      state = AsyncData(
        fetchedProducts.map((p) => ProductModel.fromEntity(p)).toList(),
      );
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
