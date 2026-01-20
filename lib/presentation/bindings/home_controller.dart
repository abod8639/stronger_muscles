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
  }

  Future<void> fetchProductsForSection(int index, {String? categoryId}) async {
    selectedSectionIndex.value = index;
    isLoading.value = true;
    isError.value = false;
    isConnectionError.value = false;
    errorMessage.value = '';
    
    try {
      List<ProductModel> fetchedProducts;
      
      // Use categoryId directly if provided by the controller.
      // Removed hardcoded fallback indices to ensure it's fully dynamic.
      
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
    String? categoryId;
    if (Get.isRegistered<CategoriesSectionsController>()) {
      final sectionsController = Get.find<CategoriesSectionsController>();
      final index = selectedSectionIndex.value;
      if (index >= 0 && index < sectionsController.selections.length) {
        final id = sectionsController.selections[index].id;
        categoryId = id.isEmpty ? null : id;
      }
    }

    await fetchProductsForSection(selectedSectionIndex.value, categoryId: categoryId);
    
    if (Get.isRegistered<CategoriesSectionsController>()) {
      await Get.find<CategoriesSectionsController>().fetchCategories();
    }
  }
}
