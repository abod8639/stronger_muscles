import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_di.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  int _selectedSectionIndex = 0;
  int get selectedSectionIndex => _selectedSectionIndex;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  static const int _pageSize = 20;

  @override
  FutureOr<List<ProductEntity>> build() async {
    _selectedSectionIndex = 0;
    _currentPage = 1;
    _isLoadingMore = false;
    _hasMore = true;

    final getHomeProducts = ref.watch(getHomeProductsUseCaseProvider);
    final result = await getHomeProducts(page: 1);

    return result.fold(
      (failure) {
        if (failure is CancelFailure) {
          return const [];
        }
        throw failure;
      },
      (products) {
        if (products.length < _pageSize) {
          _hasMore = false;
        }
        return products;
      },
    );
  }

  /// Fetches products filtered for a specific category section with reset pagination.
  Future<void> fetchProductsForSection(int index, {String? categoryId}) async {
    _selectedSectionIndex = index;
    _currentPage = 1;
    _isLoadingMore = false;
    _hasMore = true;

    state = const AsyncLoading();

    final getHomeProducts = ref.read(getHomeProductsUseCaseProvider);
    final result = await getHomeProducts(
      categoryId: categoryId,
      page: 1,
    );

    result.fold(
      (failure) {
        if (failure is CancelFailure) return;
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (products) {
        if (products.length < _pageSize) {
          _hasMore = false;
        }
        state = AsyncData(products);
      },
    );
  }

  /// Loads the next page of products with duplicate submission protection.
  Future<void> loadMoreProducts({String? categoryId}) async {
    if (_isLoadingMore || !_hasMore) return;

    final currentProducts = state.valueOrNull ?? const [];
    if (currentProducts.isEmpty) return;

    _isLoadingMore = true;
    final nextPage = _currentPage + 1;

    final getHomeProducts = ref.read(getHomeProductsUseCaseProvider);
    final result = await getHomeProducts(
      categoryId: categoryId,
      page: nextPage,
    );

    _isLoadingMore = false;

    result.fold(
      (failure) {
        // Retain current products on pagination error without wiping UI
      },
      (newProducts) {
        if (newProducts.isEmpty || newProducts.length < _pageSize) {
          _hasMore = false;
        }
        if (newProducts.isNotEmpty) {
          _currentPage = nextPage;
          state = AsyncData([...currentProducts, ...newProducts]);
        }
      },
    );
  }

  /// Pull-to-refresh home handler coordinating category shortcuts and product feeds.
  Future<void> refreshHome() async {
    final index = _selectedSectionIndex;
    final sectionsState = ref.read(categoriesSectionsControllerProvider);

    String? categoryId;
    if (sectionsState.hasValue &&
        index >= 0 &&
        index < (sectionsState.value?.length ?? 0)) {
      final id = sectionsState.value![index].id;
      categoryId = id.isEmpty ? null : id;
    }

    await Future.wait([
      fetchProductsForSection(index, categoryId: categoryId),
      ref.read(categoriesSectionsControllerProvider.notifier).fetchCategories(),
    ]);
  }
}
