import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

/// UseCase to create a new address or update an existing one.
class SaveAddressUseCase {
  final AddressRepository repository;

  const SaveAddressUseCase(this.repository);

  Future<AddressModel> call({int? id, required AddressModel address}) {
    if (id == null) {
      return repository.createAddress(address);
    } else {
      return repository.updateAddress(id, address);
    }
  }
}
