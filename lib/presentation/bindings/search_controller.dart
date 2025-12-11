import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'dart:math' as math;

class ProductSearchController extends GetxController {
  // Source of truth (all products for the current section)
  final _allProducts = <ProductModel>[].obs;

  // Filter states
  final searchQuery = ''.obs;
  final filterMinPrice = 0.0.obs;
  final filterMaxPrice = 1000.0.obs;

  // Computed bounds based on data
  final dataMinPrice = 0.0.obs;
  final dataMaxPrice = 1000.0.obs;

  // Output (filtered list to be displayed)
  final filteredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // React to changes in search query or price filters
    everAll([searchQuery, filterMinPrice, filterMaxPrice], (_) => _applyFilters());
  }

  /// Update the source list of products (e.g., when changing categories)
  void setProducts(List<ProductModel> products) {
    _allProducts.assignAll(products);
    _updateDataBoundsAndResetFilters();
  }

  void _updateDataBoundsAndResetFilters() {
    if (_allProducts.isEmpty) {
      dataMinPrice.value = 0.0;
      dataMaxPrice.value = 1000.0;
    } else {
      double min = _allProducts.first.price;
      double max = _allProducts.first.price;
      for (var p in _allProducts) {
        min = math.min(min, p.price);
        max = math.max(max, p.price);
      }
      dataMinPrice.value = min;
      dataMaxPrice.value = max;
    }
    
    // Reset active filters to the full range
    filterMinPrice.value = dataMinPrice.value;
    filterMaxPrice.value = dataMaxPrice.value;
    
    // Apply filters immediately
    _applyFilters();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query.trim().toLowerCase();
  }

  void applyPriceFilter(double min, double max) {
    filterMinPrice.value = min;
    filterMaxPrice.value = max;
  }

  void _applyFilters() {
    final q = searchQuery.value;
    final min = filterMinPrice.value;
    final max = filterMaxPrice.value;

    filteredProducts.assignAll(
      _allProducts.where((p) {
        final matchesName = q.isEmpty || p.name.toLowerCase().contains(q);
        final matchesPrice = p.price >= min && p.price <= max;
        return matchesName && matchesPrice;
      }).toList(),
    );
  }
}
