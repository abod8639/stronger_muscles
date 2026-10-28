import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';

/// Abstract contract for Address local storage (Hive).
abstract class AddressLocalDataSource {
  List<AddressModel> getCachedAddresses();
  Future<void> cacheAddresses(List<AddressModel> addresses);
  Future<void> cacheAddress(AddressModel address);
  Future<void> deleteAddress(int id);
  Future<void> setDefaultAddress(int id, AddressModel updatedAddress);
  Future<void> clearAddresses();
}

/// Hive-backed implementation of [AddressLocalDataSource] with resilient in-memory fallback.
class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  static const String boxName = 'addresses';
  final Box<AddressModel>? _overrideBox;
  final Map<int, AddressModel> _inMemoryFallback = {};

  AddressLocalDataSourceImpl([this._overrideBox]);

  Box<AddressModel>? get _box {
    if (_overrideBox != null) return _overrideBox;
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<AddressModel>(boxName);
    }
    return null;
  }

  @override
  List<AddressModel> getCachedAddresses() {
    final box = _box;
    if (box != null && box.isOpen) {
      return box.values.toList();
    }
    return _inMemoryFallback.values.toList();
  }

  @override
  Future<void> cacheAddresses(List<AddressModel> addresses) async {
    final box = _box;
    if (box != null && box.isOpen) {
      await box.clear();
      for (final address in addresses) {
        await box.put(address.id, address);
      }
    } else {
      _inMemoryFallback.clear();
      for (final address in addresses) {
        _inMemoryFallback[address.id] = address;
      }
    }
  }

  @override
  Future<void> cacheAddress(AddressModel address) async {
    final box = _box;
    if (box != null && box.isOpen) {
      await box.put(address.id, address);
    } else {
      _inMemoryFallback[address.id] = address;
    }
  }

  @override
  Future<void> deleteAddress(int id) async {
    final box = _box;
    if (box != null && box.isOpen) {
      await box.delete(id);
    } else {
      _inMemoryFallback.remove(id);
    }
  }

  @override
  Future<void> setDefaultAddress(int id, AddressModel updatedAddress) async {
    final box = _box;
    if (box != null && box.isOpen) {
      final all = box.values.toList();
      for (final addr in all) {
        if (addr.id == id) {
          await box.put(addr.id, updatedAddress);
        } else if (addr.isDefault) {
          await box.put(addr.id, addr.copyWith(isDefault: false));
        }
      }
    } else {
      _inMemoryFallback.updateAll((key, val) {
        if (key == id) return updatedAddress;
        if (val.isDefault) return val.copyWith(isDefault: false);
        return val;
      });
      _inMemoryFallback[id] = updatedAddress;
    }
  }

  @override
  Future<void> clearAddresses() async {
    final box = _box;
    if (box != null && box.isOpen) {
      await box.clear();
    }
    _inMemoryFallback.clear();
  }
}
