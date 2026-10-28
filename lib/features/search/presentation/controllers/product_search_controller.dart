import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/home/home_feature.dart';
import 'package:stronger_muscles/features/product/product_feature.dart'
    hide SearchProductsUseCase, searchProductsUseCaseProvider;
import 'package:stronger_muscles/features/profile/profile_feature.dart';
import 'package:stronger_muscles/features/search/domain/usecases/calculate_price_bounds_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/filter_by_price_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/search_products_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/usecase_providers.dart';

part 'product_search_controller.g.dart';

@riverpod
class ProductSearchController extends _$ProductSearchController {
  final TextEditingController textController = TextEditingController();

  Timer? _debounceTimer;

  List<ProductEntity> _localProducts = [];
  List<ProductEntity> _combinedResults = [];

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

  // ── Domain UseCases ─────────────────────────────────────────────────────
  SearchProductsUseCase get _searchProductsUseCase =>
      ref.read(searchProductsUseCaseProvider);

  FilterByPriceUseCase get _filterByPriceUseCase =>
      ref.read(filterByPriceUseCaseProvider);

  CalculatePriceBoundsUseCase get _calculatePriceBoundsUseCase =>
      ref.read(calculatePriceBoundsUseCaseProvider);

  @override
  FutureOr<List<ProductEntity>> build() {
    ref.onDispose(() {
      textController.dispose();
      _debounceTimer?.cancel();
    });

    // Initialize with home products if they are already loaded
    final homeProducts = ref.read(homeControllerProvider).valueOrNull;
    if (homeProducts != null && homeProducts.isNotEmpty) {
      _localProducts = homeProducts;
      _combinedResults = homeProducts;
      return homeProducts;
    }

    return [];
  }

  void setProducts(List<ProductEntity> products) {
    _localProducts = products;
    _updateDataBounds();
    _filterMinPrice = _dataMinPrice;
    _filterMaxPrice = _dataMaxPrice;
    _applyFilters();
  }

  /// Backward compatibility helper if models are passed
  void setProductsFromModels(List<ProductModel> models) {
    setProducts(models.map((m) => m.toEntity()).toList());
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
    final homeProducts = ref.read(homeControllerProvider).valueOrNull ?? [];
    final source = _localProducts.isNotEmpty ? _localProducts : homeProducts;

    // Use prioritized local filtering
    final results = _prioritizedLocalFilter(query, source, locale);
    _combinedResults = results;

    _updateDataBounds();
    _applyFiltersToResults(results);
  }

  /// Handles remote search with combined results
  Future<void> _handleRemoteSearch(String query) async {
    if (query.isEmpty) return;

    try {
      // Fetch remote results via use case
      final List<ProductEntity> remoteResults =
          await _searchProductsUseCase(query);

      // Merge with current local results
      final existingIds = _combinedResults.map((e) => e.id).toSet();
      final List<ProductEntity> merged = List.from(_combinedResults);

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
  List<ProductEntity> _prioritizedLocalFilter(
    String query,
    List<ProductEntity> products,
    String locale,
  ) {
    final lowerQuery = query.toLowerCase();

    final List<ProductEntity> exact = [];
    final List<ProductEntity> prefix = [];
    final List<ProductEntity> contains = [];
    final List<ProductEntity> others = [];

    for (var p in products) {
      final name = p.getLocalizedName(locale: locale).toLowerCase();
      final brand = (p.brand ?? "").toLowerCase();
      final category =
          (p.category?.getLocalizedName(locale: locale) ?? "").toLowerCase();
      final tags = p.tags.map((t) => t.toLowerCase()).toList();

      if (name == lowerQuery || brand == lowerQuery || category == lowerQuery) {
        exact.add(p);
      } else if (name.startsWith(lowerQuery) ||
          brand.startsWith(lowerQuery) ||
          category.startsWith(lowerQuery)) {
        prefix.add(p);
      } else if (name.contains(lowerQuery) ||
          brand.contains(lowerQuery) ||
          category.contains(lowerQuery) ||
          tags.any((t) => t.contains(lowerQuery))) {
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

  List<ProductEntity> _performLocalFuzzySearch(
    String query,
    List<ProductEntity> products,
    String locale,
  ) {
    if (query.isEmpty) return [];

    final fuse = Fuzzy<ProductEntity>(
      products,
      options: FuzzyOptions(
        keys: [
          WeightedKey(
            name: 'name',
            getter: (p) => p.getLocalizedName(locale: locale),
            weight: 1.0,
          ),
          WeightedKey(
            name: 'brand',
            getter: (p) => p.brand ?? "",
            weight: 0.7,
          ),
        ],
        threshold: 0.35,
      ),
    );

    return fuse.search(query).take(10).map((r) => r.item).toList();
  }

  void _updateDataBounds() {
    final source = _combinedResults.isEmpty && !_hasSearched
        ? _localProducts
        : _combinedResults;
    if (source.isEmpty) return;

    final bounds = _calculatePriceBoundsUseCase(source);
    _dataMinPrice = bounds['min']!;
    _dataMaxPrice = bounds['max']!;

    _filterMinPrice = _filterMinPrice.clamp(_dataMinPrice, _dataMaxPrice);
    _filterMaxPrice = _filterMaxPrice.clamp(_dataMinPrice, _dataMaxPrice);
  }

  void applyPriceFilter(double min, double max) {
    _filterMinPrice = min;
    _filterMaxPrice = max;
    _applyFiltersToResults(_combinedResults.isEmpty && !_hasSearched
        ? _localProducts
        : _combinedResults);
  }

  void _applyFilters() {
    _applyFiltersToResults(_localProducts);
  }

  void _applyFiltersToResults(List<ProductEntity> results) {
    final filtered =
        _filterByPriceUseCase(results, _filterMinPrice, _filterMaxPrice);
    state = AsyncData(filtered);
  }
}
