import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Immutable state for product catalog and listings.
/// Supports pagination (`isLoadingMore`, `page`, `hasMore`) and filtering.
@immutable
class ProductsState {
  final List<ProductEntity> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final String selectedCategoryId;
  final String searchQuery;
  final String? errorMessage;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.selectedCategoryId = '',
    this.searchQuery = '',
    this.errorMessage,
  });

  ProductsState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    String? selectedCategoryId,
    String? searchQuery,
    String? Function()? errorMessage,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  /// Declarative helper for backward-compatible UI matching (data, loading, error).
  R when<R>({
    required R Function(List<ProductEntity> products) data,
    required R Function() loading,
    required R Function(Object error, StackTrace? stackTrace) error,
  }) {
    if (isLoading && products.isEmpty) {
      return loading();
    }
    if (errorMessage != null && products.isEmpty) {
      return error(errorMessage!, StackTrace.current);
    }
    return data(products);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsState &&
          runtimeType == other.runtimeType &&
          listEquals(products, other.products) &&
          isLoading == other.isLoading &&
          isLoadingMore == other.isLoadingMore &&
          hasMore == other.hasMore &&
          page == other.page &&
          selectedCategoryId == other.selectedCategoryId &&
          searchQuery == other.searchQuery &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
        Object.hashAll(products),
        isLoading,
        isLoadingMore,
        hasMore,
        page,
        selectedCategoryId,
        searchQuery,
        errorMessage,
      );
}
