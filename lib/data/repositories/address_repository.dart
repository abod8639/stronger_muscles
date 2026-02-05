import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:stronger_muscles/data/models/address_model.dart';

class AddressRepository {
  final AddressService _service = Get.find<AddressService>();
  final Box<AddressModel> _box = Hive.box<AddressModel>('addresses');
  
  bool _isFetching = false;

  /// Get cached addresses
  List<AddressModel> getCachedAddresses() => _box.values.toList();

  /// Fetch and cache addresses
  Future<List<AddressModel>> getAddresses() async {
    if (_isFetching) {
      // If already fetching, wait a bit or return cache to avoid redundant calls
      // For simplicity in this case, we just return cache if it's not empty, 
      // or wait for the other call. But here we'll just prevent duplicate active calls.
      return getCachedAddresses();
    }

    try {
      _isFetching = true;
      final addresses = await _service.getAddresses();
      
      // Update cache
      await _box.clear();
      for (var address in addresses) {
        await _box.put(address.id, address);
      }
      
      return addresses;
    } on Failure catch (e) {
      if (e.type == FailureType.network && _box.isNotEmpty) {
        return _box.values.toList();
      }
      rethrow;
    } finally {
      _isFetching = false;
    }
  }

  Future<AddressModel> createAddress(AddressModel address) async {
    final newAddress = await _service.createAddress(address);
    await _box.put(newAddress.id, newAddress);
    return newAddress;
  }

  Future<AddressModel> updateAddress(int id, AddressModel address) async {
    final updatedAddress = await _service.updateAddress(id, address);
    await _box.put(updatedAddress.id, updatedAddress);
    return updatedAddress;
  }

  Future<void> deleteAddress(int id) async {
    await _service.deleteAddress(id);
    await _box.delete(id);
  }

  Future<AddressModel> setDefaultAddress(int id) async {
    final updatedAddress = await _service.setDefaultAddress(id);
    
    // Update all local items to reflect the new default
    final all = _box.values.toList();
    for (var addr in all) {
      if (addr.id == id) {
        await _box.put(addr.id, updatedAddress);
      } else if (addr.isDefault) {
        await _box.put(addr.id, addr.copyWith(isDefault: false));
      }
    }
    
    return updatedAddress;
  }
}
