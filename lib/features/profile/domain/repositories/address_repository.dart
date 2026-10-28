import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';

/// Pure Dart domain contract for address operations.
abstract class AddressRepository {
  /// Returns cached addresses synchronously.
  Either<Failure, List<AddressEntity>> getCachedAddresses();

  /// Fetches saved addresses from the remote server and updates local cache.
  Future<Either<Failure, List<AddressEntity>>> getAddresses();

  /// Creates a new user address.
  Future<Either<Failure, AddressEntity>> createAddress(AddressEntity address);

  /// Updates an existing address by [id].
  Future<Either<Failure, AddressEntity>> updateAddress(int id, AddressEntity address);

  /// Deletes a saved address by [id].
  Future<Either<Failure, Unit>> deleteAddress(int id);

  /// Sets the address with [id] as default.
  Future<Either<Failure, AddressEntity>> setDefaultAddress(int id);
}
