import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

/// UseCase to set a saved address as the default address.
class SetDefaultAddressUseCase {
  final AddressRepository repository;

  const SetDefaultAddressUseCase(this.repository);

  Future<AddressEntity> call(int id) => repository.setDefaultAddress(id);
}
