import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'package:stronger_muscles/presentation/bindings/categories_sections_controller.dart';
import 'package:stronger_muscles/presentation/bindings/search_controller.dart';

import 'package:stronger_muscles/core/errors/failures.dart';

class HomeController extends GetxController {
  final ProductService _productService = Get.put(ProductService());
  final searchController = Get.put(ProductSearchController());
  // final categoriesController = Get.put(CategoriesSectionsController());

  // Expose filtered products for the UI
  RxList<ProductModel> get products => searchController.filteredProducts;

  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;
  final isConnectionError = false.obs;
  final selectedSectionIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductsForSection(selectedSectionIndex.value);
    // categoriesController.fetchCategories();
    // categoriesController.fetchCategories();
    
  }

  Future<void> fetchProductsForSection(int index, {String? categoryId}) async {
    selectedSectionIndex.value = index;
    isLoading.value = true;
    isError.value = false;
    isConnectionError.value = false;
    errorMessage.value = '';
    
    try {
      List<ProductModel> fetchedProducts;
      
      // If categoryId is not provided, we might still be using the old index-based logic
      // but let's prioritize categoryId if present.
      if (categoryId == null && index != 0) {
        // Fallback for any legacy calls that don't pass categoryId yet
        switch (index) {
          case 1: categoryId = 'cat-protein'; break;
          case 2: categoryId = 'cat-amino'; break;
          case 3: categoryId = 'cat-vitamins'; break;
          case 4: categoryId = 'cat-preworkout'; break;
          case 5: categoryId = 'cat-recovery'; break;
          case 6: categoryId = 'cat-fatburner'; break;
          case 7: categoryId = 'cat-health'; break;
          case 8: categoryId = 'cat-mass-gainer'; break;
          case 9: categoryId = 'cat-carb'; break;
        }
      }

      fetchedProducts = await _productService.getProducts(categoryId: categoryId);
      
      // Update the search controller with the new data
      searchController.setProducts(fetchedProducts);
      
    } catch (e) {
      print('DEBUG: HomeController error: $e');
      isError.value = true;
      
      if (e is Failure) {
        errorMessage.value = e.message;
        isConnectionError.value = e.isConnectionError;
      } else {
        errorMessage.value = e.toString();
        isConnectionError.value = false;
      }

      Get.snackbar(
        isConnectionError.value ? 'خطأ في الاتصال' : 'خطأ',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        mainButton: isConnectionError.value 
          ? TextButton(
              onPressed: () => fetchProductsForSection(index), 
              child: const Text('إعادة محاولة', style: TextStyle(color: Colors.white)))
          : null,
      );
    } finally {
      isLoading.value = false;
    }
  }




  Future<void> refreshHome() async {
    await fetchProductsForSection(selectedSectionIndex.value);
    if (Get.isRegistered<CategoriesSectionsController>()) {
      Get.find<CategoriesSectionsController>().fetchCategories();
    }
  }
}
