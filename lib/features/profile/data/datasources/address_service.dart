import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_remote_datasource.dart';

part 'address_service.g.dart';

@Riverpod(keepAlive: true)
AddressService addressService(AddressServiceRef ref) {
  return AddressService(ref.watch(apiServiceProvider));
}

/// Backward compatible wrapper around [AddressRemoteDataSourceImpl].
class AddressService extends AddressRemoteDataSourceImpl {
  AddressService(super.apiService);
}
