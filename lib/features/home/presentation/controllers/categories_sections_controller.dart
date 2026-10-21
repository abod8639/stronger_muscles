import 'dart:async';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';
import 'package:stronger_muscles/features/home/domain/usecases/usecase_providers.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/language_controller.dart';

part 'categories_sections_controller.g.dart';

@riverpod
class SelectedCategoryIndex extends _$SelectedCategoryIndex {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

@riverpod
class CategoriesSectionsController extends _$CategoriesSectionsController {
  CancelToken? _cancelToken;

  @override
  FutureOr<List<SelectionEntity>> build() async {
    _cancelToken = CancelToken();

    ref.onDispose(() {
      _cancelToken?.cancel('CategoriesSectionsController disposed');
      _cancelToken = null;
    });

    final getHomeShortcuts = ref.watch(getHomeShortcutsUseCaseProvider);
    final locale = ref.watch(languageControllerProvider);
    final langCode = locale.languageCode;

    final result = await getHomeShortcuts(
      langCode: langCode,
      cancelToken: _cancelToken,
    );

    return result.fold(
      (failure) {
        if (failure is CancelFailure) {
          return const [];
        }
        throw failure;
      },
      (shortcuts) => shortcuts,
    );
  }

  int get selectedIndex => ref.read(selectedCategoryIndexProvider);

  Future<void> fetchCategories() async {
    _cancelToken?.cancel('Refetching categories');
    _cancelToken = CancelToken();

    state = const AsyncLoading();
    final getHomeShortcuts = ref.read(getHomeShortcutsUseCaseProvider);
    final langCode = ref.read(languageControllerProvider).languageCode;

    final result = await getHomeShortcuts(
      langCode: langCode,
      cancelToken: _cancelToken,
    );

    result.fold(
      (failure) {
        if (failure is CancelFailure) return;
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (fetched) => state = AsyncData(fetched),
    );
  }

  void updateIndex(int index) {
    if (state.hasValue &&
        state.value != null &&
        index >= 0 &&
        index < state.value!.length) {
      ref.read(selectedCategoryIndexProvider.notifier).setIndex(index);
      final selectedId = state.value![index].id;

      ref
          .read(homeControllerProvider.notifier)
          .fetchProductsForSection(
            index,
            categoryId: selectedId.isEmpty ? null : selectedId,
          );
    }
  }
}
