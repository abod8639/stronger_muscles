import 'dart:async';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/domain/usecases/usecase_providers.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  int _selectedSectionIndex = 0;
  int get selectedSectionIndex => _selectedSectionIndex;
  CancelToken? _cancelToken;

  @override
  FutureOr<List<ProductEntity>> build() async {
    _cancelToken = CancelToken();

    ref.onDispose(() {
      _cancelToken?.cancel('HomeController disposed');
      _cancelToken = null;
    });

    final getHomeProducts = ref.watch(getHomeProductsUseCaseProvider);
    final result = await getHomeProducts(cancelToken: _cancelToken);

    return result.fold(
      (failure) {
        if (failure is CancelFailure) {
          return const [];
        }
        throw failure;
      },
      (products) => products,
    );
  }

  Future<void> fetchProductsForSection(int index, {String? categoryId}) async {
    _selectedSectionIndex = index;

    // Cancel in-flight network calls to prevent race conditions and wasted resources
    _cancelToken?.cancel('Section changed');
    _cancelToken = CancelToken();

    state = const AsyncLoading();

    final getHomeProducts = ref.read(getHomeProductsUseCaseProvider);
    final result = await getHomeProducts(
      categoryId: categoryId,
      cancelToken: _cancelToken,
    );

    result.fold(
      (failure) {
        if (failure is CancelFailure) {
          // Ignored when explicitly cancelled by user navigation
          return;
        }
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (products) {
        state = AsyncData(products);
      },
    );
  }

  Future<void> refreshHome() async {
    final index = _selectedSectionIndex;
    final sectionsState = ref.read(categoriesSectionsControllerProvider);

    String? categoryId;
    if (sectionsState.hasValue &&
        index >= 0 &&
        index < sectionsState.value!.length) {
      final id = sectionsState.value![index].id;
      categoryId = id.isEmpty ? null : id;
    }

    await Future.wait([
      fetchProductsForSection(index, categoryId: categoryId),
      ref.read(categoriesSectionsControllerProvider.notifier).fetchCategories(),
    ]);
  }
}
