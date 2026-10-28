import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

/// Pure Dart UseCase to retrieve saved addresses (remote or cached).
class GetAddressesUseCase {
  final AddressRepository repository;

  const GetAddressesUseCase(this.repository);

  Future<Either<Failure, List<AddressEntity>>> call() => repository.getAddresses();

  Either<Failure, List<AddressEntity>> getCached() => repository.getCachedAddresses();
}
