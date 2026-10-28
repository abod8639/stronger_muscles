import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../../../core/error/error.dart';
import '../models/checkout_params_model.dart';
import '../models/checkout_result_model.dart';

abstract class CheckoutLocalDataSource {
  Future<void> saveDraft(CheckoutParamsModel draft);
  Future<CheckoutParamsModel?> getDraft();
  Future<void> clearDraft();

  Future<void> saveLastResult(CheckoutResultModel result);
  Future<CheckoutResultModel?> getLastResult();
  Future<void> clearLastResult();
}

class CheckoutLocalDataSourceImpl implements CheckoutLocalDataSource {
  static const String boxName = 'checkout_box';
  static const String _draftKey = 'checkout_draft';
  static const String _lastResultKey = 'last_checkout_result';

  Box? _box;

  Future<Box> _getBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box(boxName);
      } else {
        _box = await Hive.openBox(boxName);
      }
      return _box!;
    } catch (e) {
      debugPrint('[CheckoutLocalDataSource] Hive box recovery required: $e');
      try {
        await Hive.deleteBoxFromDisk(boxName);
        _box = await Hive.openBox(boxName);
        return _box!;
      } catch (recoveryError) {
        throw CacheException(
          message: 'Failed to initialize or recover checkout Hive box: $recoveryError',
        );
      }
    }
  }

  @override
  Future<void> saveDraft(CheckoutParamsModel draft) async {
    try {
      final box = await _getBox();
      await box.put(_draftKey, draft.toJson());
    } catch (e) {
      throw CacheException(message: 'Error saving checkout draft: $e');
    }
  }

  @override
  Future<CheckoutParamsModel?> getDraft() async {
    try {
      final box = await _getBox();
      final data = box.get(_draftKey);
      if (data is Map) {
        return CheckoutParamsModel.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Error reading checkout draft: $e');
    }
  }

  @override
  Future<void> clearDraft() async {
    try {
      final box = await _getBox();
      await box.delete(_draftKey);
    } catch (e) {
      throw CacheException(message: 'Error clearing checkout draft: $e');
    }
  }

  @override
  Future<void> saveLastResult(CheckoutResultModel result) async {
    try {
      final box = await _getBox();
      await box.put(_lastResultKey, result.toJson());
    } catch (e) {
      throw CacheException(message: 'Error saving last checkout result: $e');
    }
  }

  @override
  Future<CheckoutResultModel?> getLastResult() async {
    try {
      final box = await _getBox();
      final data = box.get(_lastResultKey);
      if (data is Map) {
        return CheckoutResultModel.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Error reading last checkout result: $e');
    }
  }

  @override
  Future<void> clearLastResult() async {
    try {
      final box = await _getBox();
      await box.delete(_lastResultKey);
    } catch (e) {
      throw CacheException(message: 'Error clearing last checkout result: $e');
    }
  }
}
