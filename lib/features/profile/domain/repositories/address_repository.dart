import 'package:stronger_muscles/features/profile/data/models/address_model.dart';

/// Domain contract for address operations.
abstract class AddressRepository {
  List<AddressModel> getCachedAddresses();
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> createAddress(AddressModel address);
  Future<AddressModel> updateAddress(int id, AddressModel address);
  Future<void> deleteAddress(int id);
  Future<AddressModel> setDefaultAddress(int id);
}
