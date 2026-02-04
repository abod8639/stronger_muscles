import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'dart:math' as math;

class ProductSearchController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final TextEditingController textController = TextEditingController();

  // Observable state
  final _localProducts = <ProductModel>[].obs;
  final _remoteProducts = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;

  final searchQuery = ''.obs;
  final filterMinPrice = 0.0.obs;
  final filterMaxPrice = 1000.0.obs;
  final isLoadingRemote = false.obs;

  // Track the range of prices in the current data set
  final dataMinPrice = 0.0.obs;
  final dataMaxPrice = 1000.0.obs;

  @override
  void onInit() {
    super.onInit();

    // Debounce search query to avoid frequent API calls
    debounce(
      searchQuery,
      _handleSearch,
      time: const Duration(milliseconds: 500),
    );

    // Apply filters whenever the search query or price range changes
    // searchQuery is already handled by debounce above which calls _handleSearch
    // _handleSearch eventually calls _applyFilters
    everAll([filterMinPrice, filterMaxPrice], (_) => _applyFilters());
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  /// Sets the base products (e.g., from a category) and updates price bounds
  void setProducts(List<ProductModel> products) {
    _localProducts.assignAll(products);
    _updateDataBounds();
    _applyFilters();
  }

  /// Updates the search query and triggers the debounce mechanism
  void updateSearchQuery(String query) {
    searchQuery.value = query.trim();
  }

  /// Alias for updateSearchQuery to maintain compatibility with UI widgets
  void onSearchChanged(String query) => updateSearchQuery(query);

  /// Resets the search and filters
  void clearSearch() {
    textController.clear();
    searchQuery.value = '';
    _remoteProducts.clear();
    _updateDataBounds();
    _applyFilters();
  }

  /// Sets the active price filter
  void applyPriceFilter(double min, double max) {
    filterMinPrice.value = min;
    filterMaxPrice.value = max;
  }

  /// Internal handler for the debounced search query
  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) {
      _remoteProducts.clear();
      _updateDataBounds();
      _applyFilters();
      return;
    }

    isLoadingRemote.value = true;
    try {
      final results = await _productService.getProducts(query: query);
      _remoteProducts.assignAll(results);
      _updateDataBounds();
      _applyFilters();
    } catch (e) {
      debugPrint('Search Error: $e');
    } finally {
      isLoadingRemote.value = false;
    }
  }

  /// Calculates the price range (min/max) from the current source of truth
  void _updateDataBounds() {
    final source = searchQuery.isEmpty ? _localProducts : _remoteProducts;

    if (source.isEmpty) {
      dataMinPrice.value = 0.0;
      dataMaxPrice.value = 1000.0;
    } else {
      double min = source.first.price;
      double max = source.first.price;
      for (var p in source) {
        min = math.min(min, p.price);
        max = math.max(max, p.price);
      }
      dataMinPrice.value = min;
      dataMaxPrice.value = max;
    }

    // Adjust active filters if they fall outside the new bounds
    filterMinPrice.value = dataMinPrice.value;
    filterMaxPrice.value = dataMaxPrice.value;
  }

  /// Filters the source data by price and assigns it to filteredProducts
  void _applyFilters() {
    final source = searchQuery.isEmpty ? _localProducts : _remoteProducts;
    final min = filterMinPrice.value;
    final max = filterMaxPrice.value;

    final filtered = source.where((p) {
      return p.price >= min && p.price <= max;
    }).toList();

    filteredProducts.assignAll(filtered);
  }

}