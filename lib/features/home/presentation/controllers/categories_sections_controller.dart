import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_di.dart';
import 'package:stronger_muscles/features/profile/profile_feature.dart';

part 'categories_sections_controller.g.dart';

@riverpod
class SelectedCategoryIndex extends _$SelectedCategoryIndex {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

@riverpod
class CategoriesSectionsController extends _$CategoriesSectionsController {
  @override
  FutureOr<List<SelectionEntity>> build() async {
    final getHomeShortcuts = ref.watch(getHomeShortcutsUseCaseProvider);
    final locale = ref.watch(languageControllerProvider);
    final langCode = locale.languageCode;

    final result = await getHomeShortcuts(langCode: langCode);

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
    state = const AsyncLoading();
    final getHomeShortcuts = ref.read(getHomeShortcutsUseCaseProvider);
    final langCode = ref.read(languageControllerProvider).languageCode;

    final result = await getHomeShortcuts(langCode: langCode);

    result.fold(
      (failure) {
        if (failure is CancelFailure) return;
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (fetched) => state = AsyncData(fetched),
    );
  }

  void updateIndex(int index) {
    final list = state.valueOrNull;
    if (list != null && index >= 0 && index < list.length) {
      ref.read(selectedCategoryIndexProvider.notifier).setIndex(index);
      final selectedId = list[index].id;

      ref
          .read(homeControllerProvider.notifier)
          .fetchProductsForSection(
            index,
            categoryId: selectedId.isEmpty ? null : selectedId,
          );
    }
  }
}
