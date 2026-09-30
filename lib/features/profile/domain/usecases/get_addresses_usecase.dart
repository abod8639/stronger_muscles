import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

/// UseCase to retrieve saved addresses (remote or cached).
class GetAddressesUseCase {
  final AddressRepository repository;

  const GetAddressesUseCase(this.repository);

  Future<List<AddressEntity>> call() => repository.getAddresses();

  List<AddressEntity> getCached() => repository.getCachedAddresses();
}
