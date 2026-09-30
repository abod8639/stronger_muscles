import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';

/// Domain contract for address operations.
abstract class AddressRepository {
  List<AddressEntity> getCachedAddresses();
  Future<List<AddressEntity>> getAddresses();
  Future<AddressEntity> createAddress(AddressEntity address);
  Future<AddressEntity> updateAddress(int id, AddressEntity address);
  Future<void> deleteAddress(int id);
  Future<AddressEntity> setDefaultAddress(int id);
}
