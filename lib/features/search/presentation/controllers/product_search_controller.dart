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

  final searchQuery = ''.obs;
  final filterMinPrice = 0.0.obs;
  final filterMaxPrice = 1000.0.obs;
  final dataMinPrice = 0.0.obs;
  final dataMaxPrice = 1000.0.obs;

@override
  void onInit() {
    super.onInit();
    _loadInitialProducts(); 
    
    debounce(searchQuery, _handleSearch, time: const Duration(milliseconds: 500));
    everAll([filterMinPrice, filterMaxPrice], (_) => _applyFilters());
  }
  Future<void> _loadInitialProducts() async {
    try {
      setLoading(true);
      final results = await _remoteDataSource.fetchProductsFromApi("");
      setProducts(results);
    } catch (e) {
      print("Error loading initial products: $e");
    } finally {
      setLoading(false);
    }
  }
  void setProducts(List<ProductModel> products) {
    _localProducts.assignAll(products);
    _updateDataBounds();
    _applyFilters();
  }

  void updateSearchQuery(String query) => searchQuery.value = query.trim();
  void onSearchChanged(String query) => updateSearchQuery(query);

  void clearSearch() {
    textController.clear();
    searchQuery.value = '';
    _remoteProducts.clear();
    _updateDataBounds();
    _applyFilters();
  }

  void applyPriceFilter(double min, double max) {
    filterMinPrice.value = min;
    filterMaxPrice.value = max;
  }

  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) {
      _remoteProducts.clear();
      _updateDataBounds();
      _applyFilters();
      return;
    }

    try {
      setLoading(true);
      resetState();
      // استخدام الـ Remote DataSource
      final results = await _remoteDataSource.fetchProductsFromApi(query);
      _remoteProducts.assignAll(results);
      _updateDataBounds();
      _applyFilters();
    } catch (e) {
      handleError(e, title: 'خطأ في البحث');
    } finally {
      setLoading(false);
    }
  }

  void _updateDataBounds() {
    final source = searchQuery.isEmpty ? _localProducts : _remoteProducts;
    // استخدام الـ Local DataSource للحسابات
    final bounds = _localDataSource.calculatePriceBounds(source);
    
    dataMinPrice.value = bounds['min']!;
    dataMaxPrice.value = bounds['max']!;
    filterMinPrice.value = dataMinPrice.value;
    filterMaxPrice.value = dataMaxPrice.value;
  }

  void _applyFilters() {
    final source = searchQuery.isEmpty ? _localProducts : _remoteProducts;
    // استخدام الـ Local DataSource للفلترة
    final filtered = _localDataSource.filterByPrice(
      source, 
      filterMinPrice.value, 
      filterMaxPrice.value
    );
    filteredProducts.assignAll(filtered);
  }
}