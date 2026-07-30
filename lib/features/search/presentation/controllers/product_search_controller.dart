import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_local_datasource.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_remote_datasource.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/language_controller.dart';

part 'product_search_controller.g.dart';

@riverpod
class ProductSearchController extends _$ProductSearchController {
  final SearchLocalDataSource _localDataSource = SearchLocalDataSource();
  final TextEditingController textController = TextEditingController();
  
  Timer? _debounceTimer;

  List<ProductModel> _localProducts = [];
  List<ProductModel> _combinedResults = [];

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
      _debounceTimer?.cancel();
    });
    
    // Initialize with home products if they are already loaded
    final homeProducts = ref.read(homeControllerProvider).value;
    if (homeProducts != null && homeProducts.isNotEmpty) {
      _localProducts = homeProducts;
      _combinedResults = homeProducts;
      return homeProducts;
    }
    
    return [];
  }

  void setProducts(List<ProductModel> products) {
    _localProducts = products;
    _updateDataBounds();
    _filterMinPrice = _dataMinPrice;
    _filterMaxPrice = _dataMaxPrice;
    _applyFilters();
  }

  void onSearchChanged(String query) {
    _searchQuery = query.trim();
    
    // 1. Instant local search for immediate feedback
    _performLocalSearchOnly(_searchQuery);

    // 2. Debounce remote search
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _handleRemoteSearch(_searchQuery);
    });
  }

  /// Alias for onSearchChanged to maintain backward compatibility
  void updateSearchQuery(String query) {
    onSearchChanged(query);
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _searchQuery = "";
    _hasSearched = false;
    textController.clear();
    _combinedResults = _localProducts;
    _updateDataBounds();
    state = AsyncData(_localProducts);
  }

  /// Performs an instant local search on the provided query
  void _performLocalSearchOnly(String query) {
    if (query.isEmpty) {
      _hasSearched = false;
      _combinedResults = _localProducts;
      state = AsyncData(_localProducts);
      return;
    }

    _hasSearched = true;
    final locale = ref.read(languageControllerProvider).languageCode;
    final homeProducts = ref.read(homeControllerProvider).value ?? [];
    
    // Use prioritized local filtering
    final results = _prioritizedLocalFilter(query, homeProducts, locale);
    _combinedResults = results;
    
    _updateDataBounds();
    _applyFiltersToResults(results);
  }

  /// Handles remote search with combined results
  Future<void> _handleRemoteSearch(String query) async {
    if (query.isEmpty) return;

    try {
      final remoteDataSource = ref.read(searchRemoteDataSourceProvider);
      
      // Fetch remote results
      final List<ProductModel> remoteResults = await remoteDataSource.fetchProductsFromApi(query);

      // Merge with current local results
      final existingIds = _combinedResults.map((e) => e.id).toSet();
      final List<ProductModel> merged = List.from(_combinedResults);
      
      for (var product in remoteResults) {
        if (!existingIds.contains(product.id)) {
          merged.add(product);
        }
      }

      _combinedResults = merged;
      _updateDataBounds();
      _applyFiltersToResults(merged);
    } catch (e, st) {
      // Don't overwrite state with error if we already have local results
      if (_combinedResults.isEmpty) {
        state = AsyncError(e, st);
      }
    }
  }

  /// Prioritized Local Filter: Exact > Prefix > Contains > Fuzzy
  List<ProductModel> _prioritizedLocalFilter(String query, List<ProductModel> products, String locale) {
    final lowerQuery = query.toLowerCase();
    
    final List<ProductModel> exact = [];
    final List<ProductModel> prefix = [];
    final List<ProductModel> contains = [];
    final List<ProductModel> others = [];

    for (var p in products) {
      final name = p.getLocalizedName(locale: locale).toLowerCase();
      final brand = (p.brand ?? "").toLowerCase();
      final category = (p.category?.getLocalizedName(locale: locale) ?? "").toLowerCase();
      final tags = p.tags.map((t) => t.toLowerCase()).toList();

      if (name == lowerQuery || brand == lowerQuery || category == lowerQuery) {
        exact.add(p);
      } else if (name.startsWith(lowerQuery) || brand.startsWith(lowerQuery) || category.startsWith(lowerQuery)) {
        prefix.add(p);
      } else if (name.contains(lowerQuery) || brand.contains(lowerQuery) || category.contains(lowerQuery) || tags.any((t) => t.contains(lowerQuery))) {
        contains.add(p);
      } else {
        others.add(p);
      }
    }

    final combined = [...exact, ...prefix, ...contains];
    
    // If we have few results, use fuzzy as fallback
    if (combined.length < 5) {
      final fuzzyResults = _performLocalFuzzySearch(query, products, locale);
      final existingIds = combined.map((e) => e.id).toSet();
      for (var f in fuzzyResults) {
        if (!existingIds.contains(f.id)) {
          combined.add(f);
        }
      }
    }

    return combined;
  }

  List<ProductModel> _performLocalFuzzySearch(String query, List<ProductModel> products, String locale) {
    if (query.isEmpty) return [];

    final fuse = Fuzzy<ProductModel>(
      products,
      options: FuzzyOptions(
        keys: [
          WeightedKey(name: 'name', getter: (p) => p.getLocalizedName(locale: locale), weight: 1.0),
          WeightedKey(name: 'brand', getter: (p) => p.brand ?? "", weight: 0.7),
        ],
        threshold: 0.35,
      ),
    );

    return fuse.search(query).take(10).map((r) => r.item).toList();
  }

  void _updateDataBounds() {
    final source = _combinedResults.isEmpty && !_hasSearched ? _localProducts : _combinedResults;
    if (source.isEmpty) return;

    final bounds = _localDataSource.calculatePriceBounds(source);
    _dataMinPrice = bounds['min']!;
    _dataMaxPrice = bounds['max']!;

    _filterMinPrice = _filterMinPrice.clamp(_dataMinPrice, _dataMaxPrice);
    _filterMaxPrice = _filterMaxPrice.clamp(_dataMinPrice, _dataMaxPrice);
  }

  void applyPriceFilter(double min, double max) {
    _filterMinPrice = min;
    _filterMaxPrice = max;
    _applyFiltersToResults(_combinedResults.isEmpty && !_hasSearched ? _localProducts : _combinedResults);
  }

  void _applyFilters() {
    _applyFiltersToResults(_localProducts);
  }

  void _applyFiltersToResults(List<ProductModel> results) {
    final filtered = _localDataSource.filterByPrice(results, _filterMinPrice, _filterMaxPrice);
    state = AsyncData(filtered);
  }
}
