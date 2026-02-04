import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ProductSearchController extends GetxController {
  final RxList<ProductModel> _allProducts = <ProductModel>[].obs;
  
  final RxString searchQuery = ''.obs;


  RxList<ProductModel> get filteredProducts {
    if (searchQuery.isEmpty) {
      return _allProducts;
    } else {
      return _allProducts
          .where((product) =>
              product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              (product.brand?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false))
          .toList()
          .obs;
    }
  }

  void setProducts(List<ProductModel> products) {
    _allProducts.assignAll(products);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  @override
  void onClose() {
    _allProducts.clear();
    super.onClose();
  }
}