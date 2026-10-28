import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/payment/data/models/payment_method_model.dart';

/// Contract for local caching of payment methods.
abstract class PaymentLocalDataSource {
  Future<List<PaymentMethodModel>> getCachedPaymentMethods();
  Future<void> cachePaymentMethods(List<PaymentMethodModel> methods);
  Future<void> clearCache();
}

/// Concrete Hive implementation of [PaymentLocalDataSource] with in-memory fallback.
class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  static const String boxName = 'payment_methods_box';
  static const String _cachedMethodsKey = 'cached_payment_methods';

  Box? _box;
  final Map<String, dynamic> _inMemoryFallback = {};
  bool _hiveFailed = false;

  PaymentLocalDataSourceImpl([this._box]);

  Future<Box?> _getBoxSafe() async {
    if (_box != null && _box!.isOpen) return _box;
    if (_hiveFailed) return null;
    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box(boxName);
      } else {
        _box = await Hive.openBox(boxName);
      }
      return _box;
    } catch (e) {
      _hiveFailed = true;
      debugPrint('[PaymentLocalDataSource] Hive fallback active: $e');
      return null;
    }
  }

  @override
  Future<List<PaymentMethodModel>> getCachedPaymentMethods() async {
    try {
      final box = await _getBoxSafe();
      if (box != null) {
        final dynamic rawList = box.get(_cachedMethodsKey);
        if (rawList is List) {
          return rawList
              .map((item) =>
                  PaymentMethodModel.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();
        }
      }
      final dynamic fallbackList = _inMemoryFallback[_cachedMethodsKey];
      if (fallbackList is List) {
        return fallbackList
            .map((item) =>
                PaymentMethodModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('[PaymentLocalDataSource] Error reading cached payment methods: $e');
      return [];
    }
  }

  @override
  Future<void> cachePaymentMethods(List<PaymentMethodModel> methods) async {
    try {
      final jsonList = methods.map((m) => m.toJson()).toList();
      final box = await _getBoxSafe();
      if (box != null) {
        await box.put(_cachedMethodsKey, jsonList);
      }
      _inMemoryFallback[_cachedMethodsKey] = jsonList;
    } catch (e) {
      debugPrint('[PaymentLocalDataSource] Error caching payment methods: $e');
      _inMemoryFallback[_cachedMethodsKey] = methods.map((m) => m.toJson()).toList();
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await _getBoxSafe();
      if (box != null) {
        await box.delete(_cachedMethodsKey);
      }
      _inMemoryFallback.remove(_cachedMethodsKey);
    } catch (e) {
      debugPrint('[PaymentLocalDataSource] Error clearing cache: $e');
      _inMemoryFallback.remove(_cachedMethodsKey);
    }
  }
}
