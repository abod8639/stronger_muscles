import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/search/search_providers.dart';

part 'search_history_controller.g.dart';

@riverpod
class SearchHistory extends _$SearchHistory {
  @override
  List<String> build() {
    final result = ref.watch(getSearchHistoryUseCaseProvider).call();
    return result.fold(
      (failure) => const [],
      (history) => history,
    );
  }

  Future<void> add(String query) async {
    if (query.trim().isEmpty) return;
    final result =
        await ref.read(addSearchTermUseCaseProvider).call(query.trim());
    result.fold(
      (failure) {},
      (updated) => state = updated,
    );
  }

  Future<void> remove(String query) async {
    final result =
        await ref.read(removeSearchTermUseCaseProvider).call(query);
    result.fold(
      (failure) {},
      (updated) => state = updated,
    );
  }

  Future<void> clear() async {
    final result =
        await ref.read(clearSearchHistoryUseCaseProvider).call();
    result.fold(
      (failure) {},
      (_) => state = const [],
    );
  }
}
