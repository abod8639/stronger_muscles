import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

/// UseCase to retrieve saved addresses (remote or cached).
class GetAddressesUseCase {
  final AddressRepository repository;

  const GetAddressesUseCase(this.repository);

  Future<List<AddressModel>> call() => repository.getAddresses();

  List<AddressModel> getCached() => repository.getCachedAddresses();
}
