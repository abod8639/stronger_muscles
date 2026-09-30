import 'dart:async';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_service.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

part 'address_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AddressRepository addressRepository(AddressRepositoryRef ref) {
  return AddressRepositoryImpl(ref.watch(addressServiceProvider));
}

/// Concrete implementation of [AddressRepository].
/// Handles remote API synchronization and Hive caching,
/// mapping between internal [AddressModel] and domain [AddressEntity].
class AddressRepositoryImpl implements AddressRepository {
  final AddressService _service;
  final Box<AddressModel> _box = Hive.box<AddressModel>('addresses');

  AddressRepositoryImpl(this._service);

  Completer<List<AddressEntity>>? _fetchCompleter;

  @override
  List<AddressEntity> getCachedAddresses() =>
      _box.values.map((a) => a.toEntity()).toList();

  @override
  Future<List<AddressEntity>> getAddresses() async {
    if (_fetchCompleter != null) {
      return _fetchCompleter!.future;
    }

    _fetchCompleter = Completer<List<AddressEntity>>();

    try {
      final addresses = await _service.getAddresses();

      await _box.clear();
      for (var address in addresses) {
        await _box.put(address.id, address);
      }

      final entities = addresses.map((a) => a.toEntity()).toList();
      _fetchCompleter!.complete(entities);
      return entities;
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

  @override
  Future<AddressEntity> createAddress(AddressEntity address) async {
    final model = AddressModel.fromEntity(address);
    final newAddress = await _service.createAddress(model);
    await _box.put(newAddress.id, newAddress);
    return newAddress.toEntity();
  }

  @override
  Future<AddressEntity> updateAddress(int id, AddressEntity address) async {
    final model = AddressModel.fromEntity(address);
    final updatedAddress = await _service.updateAddress(id, model);
    await _box.put(updatedAddress.id, updatedAddress);
    return updatedAddress.toEntity();
  }

  @override
  Future<void> deleteAddress(int id) async {
    await _service.deleteAddress(id);
    await _box.delete(id);
  }

  @override
  Future<AddressEntity> setDefaultAddress(int id) async {
    final updatedAddress = await _service.setDefaultAddress(id);

    final all = _box.values.toList();
    for (var addr in all) {
      if (addr.id == id) {
        await _box.put(addr.id, updatedAddress);
      } else if (addr.isDefault) {
        await _box.put(addr.id, addr.copyWith(isDefault: false));
      }
    }

    return updatedAddress.toEntity();
  }
}
