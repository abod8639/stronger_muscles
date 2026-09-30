import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/delete_address_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/get_addresses_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/save_address_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/set_default_address_usecase.dart';

class FakeAddressRepository implements AddressRepository {
  List<AddressModel> addresses;
  Exception? exceptionToThrow;

  FakeAddressRepository({
    this.addresses = const [],
    this.exceptionToThrow,
  });

  @override
  List<AddressModel> getCachedAddresses() => List.from(addresses);

  @override
  Future<List<AddressModel>> getAddresses() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return List.from(addresses);
  }

  @override
  Future<AddressModel> createAddress(AddressModel address) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    addresses = [...addresses, address];
    return address;
  }

  @override
  Future<AddressModel> updateAddress(int id, AddressModel address) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    addresses = addresses.map((a) => a.id == id ? address : a).toList();
    return address;
  }

  @override
  Future<void> deleteAddress(int id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    addresses = addresses.where((a) => a.id != id).toList();
  }

  @override
  Future<AddressModel> setDefaultAddress(int id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    late AddressModel defaultAddr;
    addresses = addresses.map((a) {
      if (a.id == id) {
        defaultAddr = a.copyWith(isDefault: true);
        return defaultAddr;
      }
      return a.copyWith(isDefault: false);
    }).toList();
    return defaultAddr;
  }
}

void main() {
  const sampleAddress1 = AddressModel(
    id: 1,
    fullName: 'Mohamed Ali',
    phone: '+966500000001',
    street: 'King Fahd Rd',
    city: 'Riyadh',
    isDefault: true,
  );

  const sampleAddress2 = AddressModel(
    id: 2,
    fullName: 'Khaled Omar',
    phone: '+966500000002',
    street: 'Tahlia St',
    city: 'Jeddah',
    isDefault: false,
  );

  group('GetAddressesUseCase Tests', () {
    test('successfully retrieves addresses from repository', () async {
      final fakeRepo = FakeAddressRepository(
        addresses: [sampleAddress1, sampleAddress2],
      );
      final useCase = GetAddressesUseCase(fakeRepo);

      final result = await useCase();

      expect(result.length, 2);
      expect(result.first.fullName, 'Mohamed Ali');
    });

    test('rethrows exception when repository fails', () async {
      final fakeRepo = FakeAddressRepository(
        exceptionToThrow: Exception('Database error'),
      );
      final useCase = GetAddressesUseCase(fakeRepo);

      expect(() => useCase(), throwsA(isA<Exception>()));
    });
  });

  group('SaveAddressUseCase Tests', () {
    test('successfully creates a new address when id is null', () async {
      final fakeRepo = FakeAddressRepository(addresses: [sampleAddress1]);
      final useCase = SaveAddressUseCase(fakeRepo);

      final created = await useCase(address: sampleAddress2);

      expect(fakeRepo.addresses.length, 2);
      expect(created.id, 2);
    });

    test('successfully updates existing address when id is provided', () async {
      final fakeRepo = FakeAddressRepository(addresses: [sampleAddress1]);
      final useCase = SaveAddressUseCase(fakeRepo);

      const updated = AddressModel(
        id: 1,
        fullName: 'Mohamed Updated',
        street: 'King Fahd Rd 2',
        city: 'Riyadh',
      );

      final result = await useCase(id: 1, address: updated);

      expect(result.fullName, 'Mohamed Updated');
      expect(fakeRepo.addresses.first.fullName, 'Mohamed Updated');
    });

    test('rethrows exception when save fails', () async {
      final fakeRepo = FakeAddressRepository(
        exceptionToThrow: Exception('Save failed'),
      );
      final useCase = SaveAddressUseCase(fakeRepo);

      expect(() => useCase(address: sampleAddress1), throwsA(isA<Exception>()));
    });
  });

  group('DeleteAddressUseCase Tests', () {
    test('successfully deletes address by ID', () async {
      final fakeRepo = FakeAddressRepository(
        addresses: [sampleAddress1, sampleAddress2],
      );
      final useCase = DeleteAddressUseCase(fakeRepo);

      await useCase(1);

      expect(fakeRepo.addresses.length, 1);
      expect(fakeRepo.addresses.first.id, 2);
    });

    test('rethrows exception when deletion fails', () async {
      final fakeRepo = FakeAddressRepository(
        exceptionToThrow: Exception('Delete failed'),
      );
      final useCase = DeleteAddressUseCase(fakeRepo);

      expect(() => useCase(1), throwsA(isA<Exception>()));
    });
  });

  group('SetDefaultAddressUseCase Tests', () {
    test('updates default address correctly', () async {
      final fakeRepo = FakeAddressRepository(
        addresses: [sampleAddress1, sampleAddress2],
      );
      final useCase = SetDefaultAddressUseCase(fakeRepo);

      final updated = await useCase(2);

      expect(updated.isDefault, isTrue);
      final updatedDefault = fakeRepo.addresses.firstWhere((a) => a.id == 2);
      final updatedOld = fakeRepo.addresses.firstWhere((a) => a.id == 1);
      expect(updatedDefault.isDefault, isTrue);
      expect(updatedOld.isDefault, isFalse);
    });

    test('rethrows exception when set default fails', () async {
      final fakeRepo = FakeAddressRepository(
        exceptionToThrow: Exception('Update failed'),
      );
      final useCase = SetDefaultAddressUseCase(fakeRepo);

      expect(() => useCase(2), throwsA(isA<Exception>()));
    });
  });
}
