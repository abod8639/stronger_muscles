import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'dart:math' as math;
import 'dart:async';

class ProductSearchController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final TextEditingController textController = TextEditingController();

  // Source of truth (all products for the current section/view)
  final _localProducts = <ProductModel>[].obs;
  
  // Remote search results
  final _remoteProducts = <ProductModel>[].obs;

  // States
  final searchQuery = ''.obs;
  final filterMinPrice = 0.0.obs;
  final filterMaxPrice = 1000.0.obs;
  final isLoadingRemote = false.obs;

  // Computed bounds based on data
  final dataMinPrice = 0.0.obs;
  final dataMaxPrice = 1000.0.obs;

  // Output (filtered list to be displayed)
  final filteredProducts = <ProductModel>[].obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    // React to changes in search query or price filters
    // We use debounce for the search query to avoid heavy API calls
    debounce(searchQuery, (query) => _onDebouncedSearch(query), time: const Duration(milliseconds: 500));
    
    // For price filters, we can apply locally immediately
    everAll([filterMinPrice, filterMaxPrice], (_) => _applyFilters());
  }

  @override
  void onClose() {
    _debounce?.cancel();
    textController.dispose();
    super.onClose();
  }

  /// Update the source list of products (e.g., when changing categories)
  void setProducts(List<ProductModel> products) {
    _localProducts.assignAll(products);
    _updateDataBoundsAndResetFilters();
  }

  void _updateDataBoundsAndResetFilters() {
    final source = searchQuery.value.isEmpty ? _localProducts : _remoteProducts;
    
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
    
    // Reset active filters to the full range of the current data
    filterMinPrice.value = dataMinPrice.value;
    filterMaxPrice.value = dataMaxPrice.value;
    
    // Apply filters immediately
    _applyFilters();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query.trim();
  }

  void clearSearch() {
    textController.clear();
    searchQuery.value = '';
    _remoteProducts.clear();
    _applyFilters();
  }

  void _onDebouncedSearch(String query) async {
    print('DEBUG: _onDebouncedSearch triggered with: "$query"');
    if (query.isEmpty) {
      print('DEBUG: Query empty, clearing remote results');
      _remoteProducts.clear();
      _applyFilters();
      return;
    }

    isLoadingRemote.value = true;
    try {
      print('DEBUG: Calling ProductService.getProducts with search: $query');
      final results = await _productService.getProducts(query: query);
      print('DEBUG: Received ${results.length} results from server');
      _remoteProducts.assignAll(results);
      
      // Update bounds based on remote search results
      _updateDataBoundsAndResetFilters();
    } catch (e) {
      print('DEBUG: Search Error: $e');
    } finally {
      isLoadingRemote.value = false;
    }
  }

  void applyPriceFilter(double min, double max) {
    filterMinPrice.value = min;
    filterMaxPrice.value = max;
  }

  void _applyFilters() {
    final q = searchQuery.value;
    final min = filterMinPrice.value;
    final max = filterMaxPrice.value;

    final isSearching = q.isNotEmpty;
    final source = isSearching ? _remoteProducts : _localProducts;
    
    print('DEBUG: Applying filters. Mode: ${isSearching ? "Remote" : "Local"}, Source size: ${source.length}, Query: "$q", Range: $min - $max');

    filteredProducts.assignAll(
      source.where((p) {
        // If we are searching, we trust the server's name matching, so we only filter by price locally.
        // If we aren't searching (displaying category), we also don't really need name filtering here 
        // unless we wanted to filter the category list locally (which we don't currently do).
        final matchesPrice = p.price >= min && p.price <= max;
        
        // Optional: you could still have local name filtering for the category view if you wanted, 
        // but since search goes to the server, it's safer to trust the server results.
        return matchesPrice;
      }).toList(),
    );
    print('DEBUG: filteredProducts result size: ${filteredProducts.length}');
  }
}
