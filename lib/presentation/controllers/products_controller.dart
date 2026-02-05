import 'package:flutter/material.dart';
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
    // Prevent concurrent loads
    if (isLoading.value) return;

    try {
      // Offline-first: if filtering by category, show what we have in cache first
      if (query == null && categoryId != null && categoryId.isNotEmpty) {
        final cached = _repository.getCachedProducts()
            .where((p) => p.categoryId == categoryId)
            .toList();
        if (cached.isNotEmpty) {
          products.assignAll(cached);
        }
      }

      // Show loading only if we have no data at all
      if (products.isEmpty) isLoading.value = true;

      List<ProductModel> result;

      if (query != null && query.isNotEmpty) {
        result = await _repository.searchProducts(query);
      } else if (categoryId != null && categoryId.isNotEmpty) {
        result = await _repository.getProductsByCategory(categoryId);
      } else {
        result = await _repository.getProducts();
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isSnackbarOpen) return;
        Get.snackbar(
          'عذراً',
          'فشل تحديث البيانات، تأكد من اتصالك بالإنترنت',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      });
    }
    print("DEBUG: Error in ProductsController: $e");
  }
}