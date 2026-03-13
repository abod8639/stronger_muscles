import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_local_datasource.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_remote_datasource.dart';
import '../../../home/presentation/controllers/base_controller.dart';


class ProductSearchController extends BaseController {
  final SearchRemoteDataSource _remoteDataSource = SearchRemoteDataSource();
  final SearchLocalDataSource _localDataSource = SearchLocalDataSource();
  
  final TextEditingController textController = TextEditingController();

  // Observable state
  final _localProducts = <ProductModel>[].obs;
  final _remoteProducts = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final searchResults = <ProductModel>[].obs;

  final searchQuery = "".obs;
  final hasSearched = false.obs;
  final filterMinPrice = 0.0.obs;
  final filterMaxPrice = 1000.0.obs;
  final dataMinPrice = 0.0.obs;
  final dataMaxPrice = 1000.0.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, _handleSearch, time: const Duration(milliseconds: 500));
    everAll([filterMinPrice, filterMaxPrice], (_) {
      _applyFilters();
      _applySearchFilters();
    });
  }



  void setProducts(List<ProductModel> products) {
    _localProducts.assignAll(products);
    _updateDataBounds();
    if (dataMinPrice.value <= dataMaxPrice.value) {
      filterMinPrice.value = dataMinPrice.value;
      filterMaxPrice.value = dataMaxPrice.value;
    }
    _applyFilters();
  }

  void clearSearch() {
    textController.clear();
    searchQuery.value = '';
    hasSearched.value = false;
    _remoteProducts.clear();
    searchResults.clear();
    _updateDataBounds();
    if (dataMinPrice.value <= dataMaxPrice.value) {
      filterMinPrice.value = dataMinPrice.value;
      filterMaxPrice.value = dataMaxPrice.value;
    }
    _applyFilters();
  }
  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) {
      _remoteProducts.clear();
      searchResults.clear();
      hasSearched.value = false;
      _updateDataBounds();
      if (dataMinPrice.value <= dataMaxPrice.value) {
        filterMinPrice.value = dataMinPrice.value;
        filterMaxPrice.value = dataMaxPrice.value;
      }
      _applySearchFilters();
      return;
    }
    try {
      setLoading(true);
      resetState();
      final results = await _remoteDataSource.fetchProductsFromApi(query);
      _remoteProducts.assignAll(results);
      _updateDataBounds();
      _applySearchFilters();
      hasSearched.value = true;
    } catch (e) {
      handleError(e, title: 'خطأ في البحث');
    } finally {
      setLoading(false);
    }
  }
  void _updateDataBounds() {
    final source = searchQuery.value.isEmpty ? _localProducts : _remoteProducts;
    if (source.isEmpty) return; // حماية من القوائم الفارغة

    final bounds = _localDataSource.calculatePriceBounds(source);
    dataMinPrice.value = bounds['min']!;
    dataMaxPrice.value = bounds['max']!;
  }

  void updateSearchQuery(String query) => searchQuery.value = query.trim();

  void onSearchChanged(String query) => updateSearchQuery(query);


  void applyPriceFilter(double min, double max) {
    filterMinPrice.value = min;
    filterMaxPrice.value = max;
    _applyFilters();
    _applySearchFilters();
  }

  void _applyFilters() {
    final filtered = _localDataSource.filterByPrice(
      _localProducts,
      filterMinPrice.value,
      filterMaxPrice.value,
    );
    filteredProducts.assignAll(filtered);
  }

  void _applySearchFilters() {
    final filtered = _localDataSource.filterByPrice(
      _remoteProducts,
      filterMinPrice.value,
      filterMaxPrice.value,
    );
    searchResults.assignAll(filtered);
  }
}