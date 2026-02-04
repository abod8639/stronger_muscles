import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart'; // استخدام الـ Repository
import 'package:stronger_muscles/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/presentation/controllers/search_controller.dart';
import 'package:stronger_muscles/core/errors/failures.dart';

// الثوابت التنظيمية
const String _connectionErrorMsg = 'خطأ في الاتصال';
const String _errorMsg = 'خطأ';
const String _retryButtonLabel = 'إعادة محاولة';
const int _snackbarDurationSeconds = 5;
const SnackPosition _snackbarPosition = SnackPosition.BOTTOM;

class HomeController extends GetxController {
  // الاعتماد على الـ Repository بدلاً من الـ Service
  final ProductRepository _productRepository = Get.find<ProductRepository>();
  final _searchController = Get.find<ProductSearchController>();

  // ربط المنتجات بالـ SearchController لعرض النتائج المفلترة
  RxList get products => _searchController.filteredProducts;

  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;
  final isConnectionError = false.obs;
  final selectedSectionIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // التحميل الأولي للمنتجات (يعرض الكاش أولاً بفضل الـ Repository)
    _loadInitialProducts();
  }

  Future<void> _loadInitialProducts() async {
    // عرض بيانات الكاش فوراً لسرعة الاستجابة
    _searchController.setProducts(_productRepository.getCachedProducts());
    // ثم تحديث البيانات من السيرفر
    await fetchProductsForSection(selectedSectionIndex.value);
  }

  Future<void> fetchProductsForSection(int index, {String? categoryId}) async {
    selectedSectionIndex.value = index;
    
    // إظهار التحميل فقط إذا لم تكن هناك بيانات كاش معروضة
    if (products.isEmpty) isLoading.value = true;
    
    isError.value = false;
    isConnectionError.value = false;
    errorMessage.value = '';

    try {
      final fetchedProducts = await _productRepository.getProductById(

        categoryId ?? ""
      );

      _searchController.setProducts(fetchedProducts as List<ProductModel>);
    } catch (e) {
      _handleFetchError(e, index);
    } finally {
      isLoading.value = false;
    }
  }

  /// وظيفة تحديث الصفحة (Pull to refresh)
  Future<void> refreshHome() async {
    String? categoryId;
    
    if (Get.isRegistered<CategoriesSectionsController>()) {
      final sectionsCtrl = Get.find<CategoriesSectionsController>();
      final idx = selectedSectionIndex.value;
      
      if (idx >= 0 && idx < sectionsCtrl.selections.length) {
        final id = sectionsCtrl.selections[idx].id;
        categoryId = id.isEmpty ? null : id;
      }
      // تحديث التصنيفات أيضاً
      await sectionsCtrl.fetchCategories();
    }

    await fetchProductsForSection(selectedSectionIndex.value, categoryId: categoryId);
  }

  void _handleFetchError(dynamic e, int index) {
    print('❌ Home: Error fetching products: $e');
    isError.value = true;

    if (e is Failure) {
      errorMessage.value = e.message;
      isConnectionError.value = e.type == FailureType.network;
    } else {
      errorMessage.value = e.toString();
    }

    // إظهار تنبيه فقط في حالة عدم وجود بيانات سابقة (Fallback)
    if (products.isEmpty) {
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
                child: const Text(_retryButtonLabel, style: TextStyle(color: Colors.white)),
              )
            : null,
      );
    }
  }
}