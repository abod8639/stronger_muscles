import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_cached_products_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/search_products_usecase.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/products_state.dart';
import 'package:stronger_muscles/features/product/product_providers.dart';

/// StateNotifier responsible for managing product catalog state, search, filtering, and pagination.
/// Strictly follows Clean Architecture with Constructor Dependency Injection and fpdart handling.
class ProductsController extends StateNotifier<ProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetCachedProductsUseCase _getCachedProductsUseCase;

  Timer? _debounceTimer;

  ProductsController({
    required GetProductsUseCase getProductsUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetCachedProductsUseCase getCachedProductsUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _searchProductsUseCase = searchProductsUseCase,
        _getCachedProductsUseCase = getCachedProductsUseCase,
        super(const ProductsState()) {
    _initialize();
  }

  void _initialize() {
    final cachedResult = _getCachedProductsUseCase();
    cachedResult.fold(
      (failure) {},
      (cached) {
        if (cached.isNotEmpty) {
          state = state.copyWith(products: cached, isLoading: false);
        }
      },
    );
    fetchProducts();
  }

  String get selectedCategoryId => state.selectedCategoryId;

  /// Fetches products (first page) with optional category filter or query.
  Future<void> fetchProducts({
    String? categoryId,
    String? query,
    bool refresh = false,
  }) async {
    final targetCategory = categoryId ?? state.selectedCategoryId;
    final targetQuery = query ?? state.searchQuery;

    state = state.copyWith(
      isLoading: state.products.isEmpty || refresh,
      selectedCategoryId: targetCategory,
      searchQuery: targetQuery,
      page: 1,
      hasMore: true,
      errorMessage: () => null,
    );

    if (targetQuery.trim().isNotEmpty) {
      final result = await _searchProductsUseCase(targetQuery);
      result.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        ),
        (products) => state = state.copyWith(
          isLoading: false,
          products: products,
          hasMore: false,
          errorMessage: () => null,
        ),
      );
    } else {
      final result = await _getProductsUseCase(
        categoryId: targetCategory.isEmpty ? null : targetCategory,
        page: 1,
      );
      result.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        ),
        (products) => state = state.copyWith(
          isLoading: false,
          products: products,
          hasMore: products.length >= 20,
          errorMessage: () => null,
        ),
      );
    }
  }

  /// Loads next page of products (pagination).
  Future<void> loadMoreProducts() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    if (state.searchQuery.trim().isNotEmpty) return;

    final nextPage = state.page + 1;
    state = state.copyWith(isLoadingMore: true);

    final result = await _getProductsUseCase(
      categoryId:
          state.selectedCategoryId.isEmpty ? null : state.selectedCategoryId,
      page: nextPage,
    );

    result.fold(
      (failure) => state = state.copyWith(isLoadingMore: false),
      (newProducts) {
        state = state.copyWith(
          isLoadingMore: false,
          page: nextPage,
          hasMore: newProducts.isNotEmpty,
          products: [...state.products, ...newProducts],
        );
      },
    );
  }

  /// Toggles or updates category filter.
  void filterByCategory(String categoryId) {
    final newCategory =
        (state.selectedCategoryId == categoryId) ? '' : categoryId;
    fetchProducts(categoryId: newCategory, refresh: true);
  }

  /// Debounced search query dispatcher.
  void searchWithDebounce(
    String query, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {
      fetchProducts(query: query);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Global provider for [ProductsController].
final productsControllerProvider =
    StateNotifierProvider<ProductsController, ProductsState>((ref) {
  return ProductsController(
    getProductsUseCase: ref.watch(getProductsUseCaseProvider),
    searchProductsUseCase: ref.watch(searchProductsUseCaseProvider),
    getCachedProductsUseCase: ref.watch(getCachedProductsUseCaseProvider),
  );
});
