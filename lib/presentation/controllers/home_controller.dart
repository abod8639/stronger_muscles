import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart';
import 'package:stronger_muscles/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/core/errors/failures.dart';

class HomeController extends GetxController {
  final ProductRepository _productRepository = Get.find<ProductRepository>();
  final searchController = Get.find<ProductSearchController>();

  // Expose filtered products for the UI
  RxList<ProductModel> get products => searchController.filteredProducts;

  // UI state
  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;
  final isConnectionError = false.obs;
  final selectedSectionIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // 1. Show cached products immediately
    final cachedProducts = _productRepository.getCachedProducts();
    if (cachedProducts.isNotEmpty) {
      searchController.setProducts(cachedProducts);
    }
    
    // 2. Fetch fresh data
    await fetchProductsForSection(selectedSectionIndex.value);
  }

  /// Fetches products for a specific section (tab) index.
  /// Optionally accepts a [categoryId] for targeted filtering.
  Future<void> fetchProductsForSection(int index, {String? categoryId}) async {
    selectedSectionIndex.value = index;
    _resetState();
    
    // Only show loading if we don't have cached data
    if (searchController.filteredProducts.isEmpty) {
    // if (searchController.products.isEmpty) {
      isLoading.value = true;
    }

    try {
      final fetchedProducts = await _productRepository.getProducts(
        categoryId: categoryId,
      );
      searchController.setProducts(fetchedProducts);
    } catch (e) {
      _handleError(e, retryAction: () => fetchProductsForSection(index, categoryId: categoryId));
    } finally {
      isLoading.value = false;
    }
  }

  /// Refreshes the current state of the home screen, including categories and products.
  Future<void> refreshHome() async {
    String? categoryId;
    
    if (Get.isRegistered<CategoriesSectionsController>()) {
      final sectionsController = Get.find<CategoriesSectionsController>();
      final index = selectedSectionIndex.value;
      
      if (index >= 0 && index < sectionsController.selections.length) {
        final id = sectionsController.selections[index].id;
        categoryId = id.isEmpty ? null : id;
      }
      
      // Refresh categories in parallel with fetching products
      await Future.wait([
        fetchProductsForSection(index, categoryId: categoryId),
        sectionsController.fetchCategories(),
      ]);
    } else {
      await fetchProductsForSection(selectedSectionIndex.value);
    }
  }

  void _resetState() {
    isError.value = false;
    isConnectionError.value = false;
    errorMessage.value = '';
  }

  void _handleError(dynamic e, {VoidCallback? retryAction}) {
    debugPrint('❌ HomeController Error: $e');
    isError.value = true;

    if (e is Failure) {
      errorMessage.value = e.message;
      isConnectionError.value = e.isConnectionError;
    } else {
      errorMessage.value = e.toString();
      isConnectionError.value = false;
    }

    _showErrorSnackbar(retryAction);
  }

  void _showErrorSnackbar(VoidCallback? retryAction) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isSnackbarOpen) return;
      Get.snackbar(
        isConnectionError.value ? 'خطأ في الاتصال' : 'خطأ',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(200),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        mainButton: isConnectionError.value && retryAction != null
            ? TextButton(
                onPressed: () {
                  if (Get.isSnackbarOpen) Get.back();
                  retryAction();
                },
                child: const Text(
                  'إعادة محاولة',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            : null,
      );
    });
  }
}