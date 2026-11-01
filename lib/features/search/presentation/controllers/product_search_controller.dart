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
import 'package:stronger_muscles/features/search/search_providers.dart';

part 'product_search_controller.g.dart';

@Riverpod(keepAlive: true)
class ProductSearchController extends _$ProductSearchController {
  final TextEditingController textController = TextEditingController();

  Timer? _debounceTimer;
  int _searchRequestId = 0;

  List<ProductEntity> _localProducts = [];
  List<ProductEntity> _combinedResults = [];

  String _searchQuery = "";
  String? _selectedBrand;
  double _filterMinPrice = 0.0;
  double _filterMaxPrice = 1000.0;
  double _dataMinPrice = 0.0;
  double _dataMaxPrice = 1000.0;
  bool _hasSearched = false;
  bool _isSearching = false;

  double get filterMinPrice => _filterMinPrice;
  double get filterMaxPrice => _filterMaxPrice;
  double get dataMinPrice => _dataMinPrice;
  double get dataMaxPrice => _dataMaxPrice;
  String get searchQuery => _searchQuery;
  String? get selectedBrand => _selectedBrand;
  bool get hasSearched => _hasSearched;
  bool get isSearching => _isSearching;

  bool get isPriceFilterActive =>
      _dataMaxPrice > _dataMinPrice &&
      (_filterMinPrice > _dataMinPrice || _filterMaxPrice < _dataMaxPrice);

  List<String> get availableBrands {
    final source =
        _combinedResults.isNotEmpty ? _combinedResults : _localProducts;
    final brands = source
        .map((p) => p.brand?.trim())
        .where((b) => b != null && b.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    brands.sort();
    return brands;
  }

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

    // Listen to home products if they finish loading later
    ref.listen(homeControllerProvider, (previous, next) {
      final products = next.valueOrNull;
      if (products != null && products.isNotEmpty && _localProducts.isEmpty) {
        _localProducts = products;
        if (!_hasSearched) {
          _combinedResults = products;
          _updateDataBounds();
          _filterMinPrice = _dataMinPrice;
          _filterMaxPrice = _dataMaxPrice;
          state = AsyncData(products);
        }
      }
    });

    // Initialize with home products if they are already loaded
    final homeProducts = ref.read(homeControllerProvider).valueOrNull;
    if (homeProducts != null && homeProducts.isNotEmpty) {
      _localProducts = homeProducts;
      _combinedResults = homeProducts;
      _updateDataBounds();
      _filterMinPrice = _dataMinPrice;
      _filterMaxPrice = _dataMaxPrice;
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
    final trimmed = query.trim();
    _searchQuery = trimmed;

    if (_selectedBrand != null &&
        trimmed.toLowerCase() != _selectedBrand!.toLowerCase()) {
      _selectedBrand = null;
    }

    if (trimmed.isEmpty) {
      clearSearch();
      return;
    }

    // Debounce both local and remote search so typing is smooth and uninterrupted
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      executeSearch(trimmed);
    });
  }

  /// Executes immediate search (used by debounce completion, enter key press, or suggestion tap)
  void executeSearch(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    _searchQuery = trimmed;

    if (trimmed.isEmpty) {
      clearSearch();
      return;
    }

    _hasSearched = true;
    textController.text = trimmed;

    // 1. Instant local search
    _performLocalSearchOnly(trimmed);

    // 2. Remote search
    _handleRemoteSearch(trimmed);
  }

  /// Direct search by brand (e.g. from product details or banner tap)
  void searchByBrand(String brand) {
    _debounceTimer?.cancel();
    _searchRequestId++;
    final trimmed = brand.trim();
    _selectedBrand = trimmed;
    _searchQuery = trimmed;
    _hasSearched = true;
    textController.text = trimmed;

    // 1. Instant local search prioritizing exact brand
    _performLocalSearchOnly(trimmed);

    // 2. Immediate remote search for this brand (no debounce needed for direct click)
    _handleRemoteSearch(trimmed);
  }

  void clearBrandFilter() {
    _selectedBrand = null;
    if (_searchQuery.isNotEmpty) {
      _performLocalSearchOnly(_searchQuery);
    } else {
      clearSearch();
    }
  }

  /// Alias for onSearchChanged to maintain backward compatibility
  void updateSearchQuery(String query) {
    onSearchChanged(query);
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _searchRequestId++;
    _searchQuery = "";
    _selectedBrand = null;
    _hasSearched = false;
    _isSearching = false;
    textController.clear();
    _combinedResults = _localProducts;
    _updateDataBounds();
    _filterMinPrice = _dataMinPrice;
    _filterMaxPrice = _dataMaxPrice;
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

  /// Handles remote search with combined results via fpdart Either (Rule 3 & 4)
  Future<void> _handleRemoteSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final currentRequestId = ++_searchRequestId;
    _isSearching = true;

    // Notify UI that a background search is in progress
    if (state.hasValue) {
      state = AsyncData(state.value!);
    }

    final result = await _searchProductsUseCase(trimmed);

    // If query has changed or a newer search was started while this was in flight, discard!
    if (currentRequestId != _searchRequestId || _searchQuery.trim() != trimmed) {
      return;
    }

    _isSearching = false;

    result.fold(
      (failure) {
        // Don't overwrite state with error if we already have local results
        if (_combinedResults.isEmpty) {
          state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
        } else {
          state = AsyncData(state.value ?? _combinedResults);
        }
      },
      (remoteResults) {
        final locale = ref.read(languageControllerProvider).languageCode;
        final existingIds = _combinedResults.map((e) => e.id).toSet();
        final List<ProductEntity> newRemote = [];

        for (final product in remoteResults) {
          if (!existingIds.contains(product.id)) {
            newRemote.add(product);
          }
        }

        final allAvailable = [..._combinedResults, ...newRemote];
        final filtered = _prioritizedLocalFilter(trimmed, allAvailable, locale);

        _combinedResults = filtered;
        _updateDataBounds();
        _applyFiltersToResults(filtered);
      },
    );
  }

  /// Prioritized Local Filter: Brand Match > Exact Name > Prefix > Contains > Multi-token > Fuzzy
  List<ProductEntity> _prioritizedLocalFilter(
    String query,
    List<ProductEntity> products,
    String locale,
  ) {
    final lowerQuery = query.toLowerCase().trim();
    if (lowerQuery.isEmpty) return products;

    final tokens = lowerQuery
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    final List<ProductEntity> exactBrand = [];
    final List<ProductEntity> exactNameOrCat = [];
    final List<ProductEntity> prefix = [];
    final List<ProductEntity> contains = [];
    final List<ProductEntity> tokenMatches = [];
    final List<ProductEntity> others = [];

    for (var p in products) {
      final name = p.getLocalizedName(locale: locale).toLowerCase();
      final brand = (p.brand ?? "").toLowerCase().trim();
      final category =
          (p.category?.getLocalizedName(locale: locale) ?? "").toLowerCase();
      final tags = p.tags.map((t) => t.toLowerCase()).toList();

      final isExactBrand = brand == lowerQuery ||
          (_selectedBrand != null &&
              brand == _selectedBrand!.toLowerCase().trim());

      if (isExactBrand) {
        exactBrand.add(p);
      } else if (name == lowerQuery || category == lowerQuery) {
        exactNameOrCat.add(p);
      } else if (name.startsWith(lowerQuery) ||
          brand.startsWith(lowerQuery) ||
          category.startsWith(lowerQuery)) {
        prefix.add(p);
      } else if (name.contains(lowerQuery) ||
          brand.contains(lowerQuery) ||
          category.contains(lowerQuery) ||
          tags.any((t) => t.contains(lowerQuery))) {
        contains.add(p);
      } else if (tokens.length > 1) {
        final searchable = '$name $brand $category ${tags.join(' ')}';
        if (tokens.every((token) => searchable.contains(token))) {
          tokenMatches.add(p);
        } else {
          others.add(p);
        }
      } else {
        others.add(p);
      }
    }

    final combined = [
      ...exactBrand,
      ...exactNameOrCat,
      ...prefix,
      ...contains,
      ...tokenMatches,
    ];

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
    _dataMinPrice = bounds.min;
    _dataMaxPrice = bounds.max;

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

  void resetPriceFilter() {
    _filterMinPrice = _dataMinPrice;
    _filterMaxPrice = _dataMaxPrice;
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
