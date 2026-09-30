import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

/// UseCase to create a new address or update an existing one.
class SaveAddressUseCase {
  final AddressRepository repository;

  const SaveAddressUseCase(this.repository);

  Future<AddressEntity> call({int? id, required AddressEntity address}) {
    if (id == null) {
      return repository.createAddress(address);
    } else {
      return repository.updateAddress(id, address);
    }
  }
}
