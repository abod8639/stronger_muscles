import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

/// Pure Dart UseCase to set a saved address as the default address.
class SetDefaultAddressUseCase {
  final AddressRepository repository;

  const SetDefaultAddressUseCase(this.repository);

  Future<Either<Failure, AddressEntity>> call(int id) =>
      repository.setDefaultAddress(id);
}
