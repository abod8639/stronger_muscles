import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

/// UseCase to delete a saved address by its ID.
class DeleteAddressUseCase {
  final AddressRepository repository;

  const DeleteAddressUseCase(this.repository);

  Future<void> call(int id) => repository.deleteAddress(id);
}
