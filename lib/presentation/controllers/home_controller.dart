import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart';
import 'package:stronger_muscles/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'base_controller.dart';

class HomeController extends BaseController {
  final ProductRepository _productRepository = Get.find<ProductRepository>();
  final searchController = Get.find<ProductSearchController>();

  RxList<ProductModel> get products => searchController.filteredProducts;

  final isConnectionError = false.obs;
  final selectedSectionIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final cachedProducts = _productRepository.getCachedProducts();
    if (cachedProducts.isNotEmpty) {
      searchController.setProducts(cachedProducts);
    }
    
    await fetchProductsForSection(selectedSectionIndex.value);
  }

  /// Fetches products for a specific section (tab) index.
  Future<void> fetchProductsForSection(int index, {String? categoryId}) async {
    selectedSectionIndex.value = index;
    resetState();
    isConnectionError.value = false;
    
    if (searchController.filteredProducts.isEmpty) {
      setLoading(true);
    }

    try {
      final fetchedProducts = await _productRepository.getProducts(
        categoryId: categoryId,
      );
      searchController.setProducts(fetchedProducts);
      resetState();
    } catch (e) {
      isConnectionError.value = e is Failure && e.isConnectionError;
      handleError(e, 
        retryAction: () => fetchProductsForSection(index, categoryId: categoryId)
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshHome() async {
    String? categoryId;
    
    if (Get.isRegistered<CategoriesSectionsController>()) {
      final sectionsController = Get.find<CategoriesSectionsController>();
      final index = selectedSectionIndex.value;
      
      if (index >= 0 && index < sectionsController.selections.length) {
        final id = sectionsController.selections[index].id;
        categoryId = id.isEmpty ? null : id;
      }
      
      await Future.wait([
        fetchProductsForSection(index, categoryId: categoryId),
        sectionsController.fetchCategories(),
      ]);
    } else {
      await fetchProductsForSection(selectedSectionIndex.value);
    }
  }
}