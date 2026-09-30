import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

/// UseCase to set a saved address as the default address.
class SetDefaultAddressUseCase {
  final AddressRepository repository;

  const SetDefaultAddressUseCase(this.repository);

  Future<AddressModel> call(int id) => repository.setDefaultAddress(id);
}
