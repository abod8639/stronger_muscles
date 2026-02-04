import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart';

class ProductsController extends GetxController {
  final ProductRepository _repository = Get.find<ProductRepository>();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCategoryId = ''.obs; 

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    products.assignAll(_repository.getCachedProducts());

    await fetchProducts();
  }

  Future<void> fetchProducts({String? categoryId, String? query}) async {
    try {
      if (products.isEmpty) isLoading.value = true;

      List<ProductModel> result;

      if (query != null && query.isNotEmpty) {
        result = await _repository.searchProducts(query);
      } else if (categoryId != null && categoryId.isNotEmpty) {
        result = await _repository.getProductsByCategory(categoryId);
      } else {
        result = await _repository.getAllProducts();
      }

      products.assignAll(result);
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    selectedCategoryId.value = ''; 
    await fetchProducts();
  }

  void filterByCategory(String categoryId) {
    if (selectedCategoryId.value == categoryId) {
      selectedCategoryId.value = ''; 
      fetchProducts();
    } else {
      selectedCategoryId.value = categoryId;
      fetchProducts(categoryId: categoryId);
    }
  }

  void _handleError(dynamic e) {
    if (products.isEmpty) {
      Get.snackbar(
        'عذراً',
        'فشل تحديث البيانات، تأكد من اتصالك بالإنترنت',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
    print("DEBUG: Error in ProductsController: $e");
  }
}