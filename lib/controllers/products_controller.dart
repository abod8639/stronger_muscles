import 'package:get/get.dart';
import '../core/services/product_service.dart';
import '../data/models/product_model.dart';

class ProductsController extends GetxController {
  // Initialize Service if not found, or use Get.find if managed centrally
  final ProductService _productService = Get.put(ProductService()); 

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({String? categoryId, String? query, bool refresh = false}) async {
    try {
      if (!refresh) isLoading.value = true;
      
      if (categoryId != null) {
        selectedCategory.value = categoryId;
      }

      final fetchedProducts = await _productService.getProducts(
        categoryId: categoryId ?? (selectedCategory.value.isEmpty ? null : selectedCategory.value),
        query: query,
      );
      
      products.assignAll(fetchedProducts);
    } catch (e) {
      // Handle error cleanly
      print('Error fetching products: $e');
      Get.snackbar('خطأ', 'فشل تحميل المنتجات'); // Error: Failed to load products
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String categoryId) {
    selectedCategory.value = categoryId;
    fetchProducts(categoryId: categoryId);
  }
}
