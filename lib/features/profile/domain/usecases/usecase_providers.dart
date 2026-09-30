import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/profile/data/repositories/address_repository_impl.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/delete_address_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/get_addresses_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/save_address_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/set_default_address_usecase.dart';

part 'usecase_providers.g.dart';

@riverpod
GetAddressesUseCase getAddressesUseCase(GetAddressesUseCaseRef ref) {
  return GetAddressesUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
SaveAddressUseCase saveAddressUseCase(SaveAddressUseCaseRef ref) {
  return SaveAddressUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
DeleteAddressUseCase deleteAddressUseCase(DeleteAddressUseCaseRef ref) {
  return DeleteAddressUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
SetDefaultAddressUseCase setDefaultAddressUseCase(SetDefaultAddressUseCaseRef ref) {
  return SetDefaultAddressUseCase(ref.watch(addressRepositoryProvider));
}
