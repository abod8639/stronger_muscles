import 'package:riverpod_annotation/riverpod_annotation.dart';
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
  @override
  FutureOr<List<SelectionEntity>> build() async {
    final getHomeShortcuts = ref.watch(getHomeShortcutsUseCaseProvider);
    final locale = ref.watch(languageControllerProvider);
    final langCode = locale.languageCode;

    return getHomeShortcuts(langCode: langCode);
  }

  int get selectedIndex => ref.read(selectedCategoryIndexProvider);

  Future<void> fetchCategories() async {
    state = const AsyncLoading();
    final getHomeShortcuts = ref.read(getHomeShortcutsUseCaseProvider);
    final langCode = ref.read(languageControllerProvider).languageCode;
    try {
      final fetched = await getHomeShortcuts(langCode: langCode);
      state = AsyncData(fetched);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void updateIndex(int index) {
    if (index >= 0 && state.hasValue && index < state.value!.length) {
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
