import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_history_controller.g.dart';

@riverpod
class SearchHistory extends _$SearchHistory {
  late final Box<String> _box;
  static const _maxItems = 10;

  @override
  List<String> build() {
    _box = Hive.box<String>('search_history');
    return _box.values.toList().reversed.toList();
  }

  void add(String query) {
    if (query.trim().isEmpty) return;
    
    final normalized = query.trim().toLowerCase();
    
    // Remove if already exists to move to top
    final existingIndex = _box.values.toList().indexWhere((e) => e.toLowerCase() == normalized);
    if (existingIndex != -1) {
      _box.deleteAt(existingIndex);
    }

    _box.add(query.trim());

    // Maintain max items
    if (_box.length > _maxItems) {
      _box.deleteAt(0);
    }

    state = _box.values.toList().reversed.toList();
  }

  void remove(String query) {
    final index = _box.values.toList().indexWhere((e) => e == query);
    if (index != -1) {
      _box.deleteAt(index);
      state = _box.values.toList().reversed.toList();
    }
  }

  void clear() {
    _box.clear();
    state = [];
  }
}
