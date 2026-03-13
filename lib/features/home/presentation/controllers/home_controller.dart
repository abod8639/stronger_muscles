import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  FutureOr<List<ProductModel>> build() async {
    final productRepository = ref.watch(productRepositoryProvider.notifier);
    
    final cachedProducts = productRepository.getCachedProducts();
    if (cachedProducts.isNotEmpty) {
      _products = cachedProducts;
      // لا نحتاج لاستدعاء void هنا كقيمة، بل كعملية جانبية
      _initFetch();
      return _products;
    }
    
    await fetchProductsForSection(_selectedSectionIndex);
    return _products;
  }

  // دالة مساعدة لبدء التحميل في الخلفية دون تعطيل الـ build
  Future<void> _initFetch() async {
    await fetchProductsForSection(_selectedSectionIndex);
  }

  List<ProductModel> _products = [];
  int _selectedSectionIndex = 0;
  int get selectedSectionIndex => _selectedSectionIndex;

  Future<void> fetchProductsForSection(int index, {String? categoryId}) async {
    _selectedSectionIndex = index;
    state = const AsyncLoading();
    
    final productRepository = ref.read(productRepositoryProvider.notifier);
    try {
      final fetchedProducts = await productRepository.getProducts(
        categoryId: categoryId,
      );
      _products = fetchedProducts;
      state = AsyncData(_products);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refreshHome() async {
    final index = _selectedSectionIndex;
    final sectionsState = ref.read(categoriesSectionsControllerProvider);
    
    String? categoryId;
    if (sectionsState.hasValue && index >= 0 && index < sectionsState.value!.length) {
      final id = sectionsState.value![index].id;
      categoryId = id.isEmpty ? null : id;
    }

    await Future.wait([
      fetchProductsForSection(index, categoryId: categoryId),
      ref.read(categoriesSectionsControllerProvider.notifier).fetchCategories(),
    ]);
  }
}
