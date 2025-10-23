import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart';

class HomeController extends GetxController {
  final ProductRepository _productRepository = ProductRepository();

  final products = <ProductModel>[].obs;
  final _allProducts = <ProductModel>[].obs; // for search
  final isLoading = false.obs;
  final selectedSectionIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductsForSection(selectedSectionIndex.value);
  }

  Future<void> fetchProductsForSection(int index) async {
    selectedSectionIndex.value = index;
    isLoading.value = true;
    try {
      List<ProductModel> fetchedProducts;
      switch (index) {
        case 0:
          fetchedProducts = await _productRepository.getAllProducts();
          break;
        case 1:
          fetchedProducts = await _productRepository.getProteinProducts();
          break;
        case 2:
          fetchedProducts = await _productRepository.getCreatineProducts();
          break;
        case 3:
          fetchedProducts = await _productRepository.getAminoProducts();
          break;
        case 4:
          fetchedProducts = await _productRepository.getBCAAProducts();
          break;
        case 5:
          fetchedProducts = await _productRepository.getPreWorkoutProducts();
          break;
        case 6:
          fetchedProducts = await _productRepository.getMassGainerProducts();
          break;
        default:
          fetchedProducts = [];
      }
      products.assignAll(fetchedProducts);
      _allProducts.assignAll(fetchedProducts);
    } finally {
      isLoading.value = false;
    }
  }

  /// Simple client-side search that filters products by name.
  void onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      products.assignAll(_allProducts);
      return;
    }
    products.assignAll(
      _allProducts.where((p) => p.name.toLowerCase().contains(q)).toList(),
    );
  }
}
