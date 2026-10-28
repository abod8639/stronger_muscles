import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Local data source contract for search history and cached search results.
abstract class SearchLocalDataSource {
  List<String> getSearchHistory();
  Future<List<String>> addSearchTerm(String term);
  Future<List<String>> removeSearchTerm(String term);
  Future<void> clearSearchHistory();

  List<ProductModel> getCachedSearchResults(String query);
  Future<void> cacheSearchResults(String query, List<ProductModel> products);
}

/// Hive-backed implementation of [SearchLocalDataSource] with robust in-memory fallbacks.
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  static const String historyBoxName = 'search_history';
  static const String cacheBoxName = 'search_cache';
  static const int maxHistoryItems = 10;

  Box<String>? _historyBox;
  final List<String> _inMemoryHistory = [];
  final Map<String, List<ProductModel>> _inMemoryCache = {};
  bool _hiveFailed = false;

  SearchLocalDataSourceImpl([this._historyBox]);

  Box<String>? _getHistoryBoxSafe() {
    if (_historyBox != null && _historyBox!.isOpen) return _historyBox;
    if (_hiveFailed) return null;
    try {
      if (Hive.isBoxOpen(historyBoxName)) {
        _historyBox = Hive.box<String>(historyBoxName);
        return _historyBox;
      }
      return null;
    } catch (e) {
      _hiveFailed = true;
      debugPrint('[SearchLocalDataSource] Hive fallback active: $e');
      return null;
    }
  }

  @override
  List<String> getSearchHistory() {
    try {
      final box = _getHistoryBoxSafe();
      if (box != null && box.isOpen) {
        return box.values.toList().reversed.toList();
      }
      return List.unmodifiable(_inMemoryHistory.reversed.toList());
    } catch (e) {
      debugPrint('[SearchLocalDataSource] Error getting history: $e');
      return List.unmodifiable(_inMemoryHistory.reversed.toList());
    }
  }

  @override
  Future<List<String>> addSearchTerm(String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return getSearchHistory();

    final normalized = trimmed.toLowerCase();

    try {
      final box = _getHistoryBoxSafe();
      if (box != null && box.isOpen) {
        final existingIndex = box.values
            .toList()
            .indexWhere((e) => e.toLowerCase() == normalized);
        if (existingIndex != -1) {
          await box.deleteAt(existingIndex);
        }
        await box.add(trimmed);
        if (box.length > maxHistoryItems) {
          await box.deleteAt(0);
        }
        return box.values.toList().reversed.toList();
      }

      // In-memory fallback
      _inMemoryHistory.removeWhere((e) => e.toLowerCase() == normalized);
      _inMemoryHistory.add(trimmed);
      if (_inMemoryHistory.length > maxHistoryItems) {
        _inMemoryHistory.removeAt(0);
      }
      return List.unmodifiable(_inMemoryHistory.reversed.toList());
    } catch (e) {
      debugPrint('[SearchLocalDataSource] Error adding search term: $e');
      _inMemoryHistory.removeWhere((e) => e.toLowerCase() == normalized);
      _inMemoryHistory.add(trimmed);
      if (_inMemoryHistory.length > maxHistoryItems) {
        _inMemoryHistory.removeAt(0);
      }
      return List.unmodifiable(_inMemoryHistory.reversed.toList());
    }
  }

  @override
  Future<List<String>> removeSearchTerm(String term) async {
    try {
      final box = _getHistoryBoxSafe();
      if (box != null && box.isOpen) {
        final index = box.values.toList().indexWhere((e) => e == term);
        if (index != -1) {
          await box.deleteAt(index);
        }
        return box.values.toList().reversed.toList();
      }

      _inMemoryHistory.remove(term);
      return List.unmodifiable(_inMemoryHistory.reversed.toList());
    } catch (e) {
      debugPrint('[SearchLocalDataSource] Error removing search term: $e');
      _inMemoryHistory.remove(term);
      return List.unmodifiable(_inMemoryHistory.reversed.toList());
    }
  }

  @override
  Future<void> clearSearchHistory() async {
    try {
      final box = _getHistoryBoxSafe();
      if (box != null && box.isOpen) {
        await box.clear();
      }
      _inMemoryHistory.clear();
    } catch (e) {
      _inMemoryHistory.clear();
    }
  }

  @override
  List<ProductModel> getCachedSearchResults(String query) {
    final key = query.trim().toLowerCase();
    return _inMemoryCache[key] ?? const [];
  }

  @override
  Future<void> cacheSearchResults(
    String query,
    List<ProductModel> products,
  ) async {
    final key = query.trim().toLowerCase();
    _inMemoryCache[key] = List.from(products);
  }
}
