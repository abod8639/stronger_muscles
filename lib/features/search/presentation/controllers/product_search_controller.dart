import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_local_datasource.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_remote_datasource.dart';

part 'product_search_controller.g.dart';

@riverpod
class ProductSearchController extends _$ProductSearchController {
  final SearchLocalDataSource _localDataSource = SearchLocalDataSource();

  final TextEditingController textController = TextEditingController();

  List<ProductModel> _localProducts = [];
  List<ProductModel> _remoteProducts = [];

  String _searchQuery = "";
  double _filterMinPrice = 0.0;
  double _filterMaxPrice = 1000.0;
  double _dataMinPrice = 0.0;
  double _dataMaxPrice = 1000.0;
  bool _hasSearched = false;

  double get filterMinPrice => _filterMinPrice;
  double get filterMaxPrice => _filterMaxPrice;
  double get dataMinPrice => _dataMinPrice;
  double get dataMaxPrice => _dataMaxPrice;
  String get searchQuery => _searchQuery;
  bool get hasSearched => _hasSearched;

  @override
  FutureOr<List<ProductModel>> build() {
    ref.onDispose(() {
      textController.dispose();
    });
    return [];
  }

  void setProducts(List<ProductModel> products) {
    _localProducts = products;
    _updateDataBounds();
    _filterMinPrice = _dataMinPrice;
    _filterMaxPrice = _dataMaxPrice;
    _applyFilters();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    _handleSearch(_searchQuery);
  }

  void onSearchChanged(String query) {
    updateSearchQuery(query);
  }

  void clearSearch() {
    _searchQuery = "";
    _hasSearched = false;
    textController.clear();
    _remoteProducts = [];
    state = AsyncData(_localProducts);
  }

  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) {
      _remoteProducts = [];
      _hasSearched = false;
      _updateDataBounds();
      state = AsyncData(_localProducts);
      return;
    }

    _hasSearched = true;
    state = const AsyncLoading();
    try {
      final remoteDataSource = ref.read(searchRemoteDataSourceProvider);
      final results = await remoteDataSource.fetchProductsFromApi(query);
      _remoteProducts = results;
      _updateDataBounds();
      _applySearchFilters();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void _updateDataBounds() {
    final source = _searchQuery.isEmpty ? _localProducts : _remoteProducts;
    if (source.isEmpty) return;

    final bounds = _localDataSource.calculatePriceBounds(source);
    _dataMinPrice = bounds['min']!;
    _dataMaxPrice = bounds['max']!;

    // Keep existing filters within new bounds
    _filterMinPrice = _filterMinPrice.clamp(_dataMinPrice, _dataMaxPrice);
    _filterMaxPrice = _filterMaxPrice.clamp(_dataMinPrice, _dataMaxPrice);
  }

  void applyPriceFilter(double min, double max) {
    _filterMinPrice = min;
    _filterMaxPrice = max;
    if (_searchQuery.isEmpty) {
      _applyFilters();
    } else {
      _applySearchFilters();
    }
  }

  void _applyFilters() {
    final filtered = _localDataSource.filterByPrice(
      _localProducts,
      _filterMinPrice,
      _filterMaxPrice,
    );
    state = AsyncData(filtered);
  }

  void _applySearchFilters() {
    final filtered = _localDataSource.filterByPrice(
      _remoteProducts,
      _filterMinPrice,
      _filterMaxPrice,
    );
    state = AsyncData(filtered);
  }
}
