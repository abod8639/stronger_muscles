import 'dart:async';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_service.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';

part 'address_repository.g.dart';

@Riverpod(keepAlive: true)
AddressRepository addressRepository(AddressRepositoryRef ref) {
  return AddressRepository(ref.watch(addressServiceProvider));
}

class AddressRepository {
  final AddressService _service;
  final Box<AddressModel> _box = Hive.box<AddressModel>('addresses');

  AddressRepository(this._service);

  Completer<List<AddressModel>>? _fetchCompleter;

  List<AddressModel> getCachedAddresses() => _box.values.toList();

  Future<List<AddressModel>> getAddresses() async {
    if (_fetchCompleter != null) {
      return _fetchCompleter!.future;
    }

    _fetchCompleter = Completer<List<AddressModel>>();

    try {
      final addresses = await _service.getAddresses();

      await _box.clear();
      for (var address in addresses) {
        await _box.put(address.id, address);
      }

      _fetchCompleter!.complete(addresses);
      return addresses;
    } on Failure catch (e) {
      if (e.type == FailureType.network && _box.isNotEmpty) {
        final cached = getCachedAddresses();
        _fetchCompleter!.complete(cached);
        return cached;
      }
      _fetchCompleter!.completeError(e);
      rethrow;
    } catch (e) {
      _fetchCompleter!.completeError(e);
      rethrow;
    } finally {
      _fetchCompleter = null;
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
