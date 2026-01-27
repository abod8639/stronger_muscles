import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'package:stronger_muscles/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/controllers/search_controller.dart';
import 'package:stronger_muscles/core/errors/failures.dart';

const String _connectionErrorMsg = 'خطأ في الاتصال';
const String _errorMsg = 'خطأ';
const String _retryButtonLabel = 'إعادة محاولة';
const int _snackbarDurationSeconds = 5;
const SnackPosition _snackbarPosition = SnackPosition.BOTTOM;

class HomeController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final searchController = Get.find<ProductSearchController>();

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
      final fetchedProducts = await _productService.getProducts(
        categoryId: categoryId,
      );

      // Update the search controller with the new data
      searchController.setProducts(fetchedProducts);
    } catch (e) {
      print('❌ Home: Error fetching products: $e');
      isError.value = true;

      if (e is Failure) {
        errorMessage.value = e.message;
        isConnectionError.value = e.isConnectionError;
      } else {
        errorMessage.value = e.toString();
        isConnectionError.value = false;
      }

      Get.snackbar(
        isConnectionError.value ? _connectionErrorMsg : _errorMsg,
        errorMessage.value,
        snackPosition: _snackbarPosition,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: _snackbarDurationSeconds),
        mainButton: isConnectionError.value
            ? TextButton(
                onPressed: () => fetchProductsForSection(index),
                child: const Text(
                  _retryButtonLabel,
                  style: TextStyle(color: Colors.white),
                ),
              )
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

    await fetchProductsForSection(
      selectedSectionIndex.value,
      categoryId: categoryId,
    );

    if (Get.isRegistered<CategoriesSectionsController>()) {
      await Get.find<CategoriesSectionsController>().fetchCategories();
    }
  }

  
}
