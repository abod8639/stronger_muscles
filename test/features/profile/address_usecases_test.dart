import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/delete_address_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/get_addresses_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/save_address_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/set_default_address_usecase.dart';

class FakeAddressRepository implements AddressRepository {
  List<AddressEntity> addresses;
  Failure? failure;

  FakeAddressRepository({
    this.addresses = const [],
    this.failure,
  });

  @override
  Either<Failure, List<AddressEntity>> getCachedAddresses() {
    if (failure != null) return Left(failure!);
    return Right(List.from(addresses));
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    if (failure != null) return Left(failure!);
    return Right(List.from(addresses));
  }

  @override
  Future<Either<Failure, AddressEntity>> createAddress(AddressEntity address) async {
    if (failure != null) return Left(failure!);
    addresses = [...addresses, address];
    return Right(address);
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress(int id, AddressEntity address) async {
    if (failure != null) return Left(failure!);
    addresses = addresses.map((a) => a.id == id ? address : a).toList();
    return Right(address);
  }

  @override
  Future<Either<Failure, Unit>> deleteAddress(int id) async {
    if (failure != null) return Left(failure!);
    addresses = addresses.where((a) => a.id != id).toList();
    return const Right(unit);
  }

  @override
  Future<Either<Failure, AddressEntity>> setDefaultAddress(int id) async {
    if (failure != null) return Left(failure!);
    late AddressEntity defaultAddr;
    addresses = addresses.map((a) {
      if (a.id == id) {
        defaultAddr = a.copyWith(isDefault: true);
        return defaultAddr;
      }
      return a.copyWith(isDefault: false);
    }).toList();
    return Right(defaultAddr);
  }
}

void main() {
  const sample1 = AddressEntity(
    id: 1,
    label: 'Home',
    street: '123 Main St',
    city: 'Riyadh',
    state: 'Riyadh Province',
    postalCode: '12345',
    country: 'KSA',
    isDefault: true,
    latitude: 24.7136,
    longitude: 46.6753,
  );

  const sample2 = AddressEntity(
    id: 2,
    label: 'Work',
    street: '456 Business Rd',
    city: 'Jeddah',
    country: 'KSA',
    isDefault: false,
  );

  group('AddressEntity Domain Tests', () {
    test('fullAddress concatenates components correctly', () {
      expect(
        sample1.fullAddress,
        '123 Main St, Riyadh, Riyadh Province, 12345, KSA',
      );
      expect(sample2.fullAddress, '456 Business Rd, Jeddah, KSA');
    });

    test('shortAddress formats city and country', () {
      expect(sample1.shortAddress, 'Riyadh, KSA');
      expect(sample2.shortAddress, 'Jeddah, KSA');
    });

    test('hasCoordinates returns true when latitude and longitude are non-null', () {
      expect(sample1.hasCoordinates, isTrue);
      expect(sample2.hasCoordinates, isFalse);
    });

    test('copyWith preserves unmodified attributes', () {
      final updated = sample1.copyWith(label: 'Vacation', isDefault: false);
      expect(updated.id, sample1.id);
      expect(updated.label, 'Vacation');
      expect(updated.isDefault, isFalse);
      expect(updated.street, sample1.street);
      expect(updated.city, sample1.city);
    });

    test('equality and hashCode conform to value object semantics', () {
      const duplicate = AddressEntity(
        id: 1,
        label: 'Home',
        street: '123 Main St',
        city: 'Riyadh',
        state: 'Riyadh Province',
        postalCode: '12345',
        country: 'KSA',
        isDefault: true,
        latitude: 24.7136,
        longitude: 46.6753,
      );

      expect(sample1, equals(duplicate));
      expect(sample1.hashCode, equals(duplicate.hashCode));
    });
  });

  group('GetAddressesUseCase Tests', () {
    test('call fetches addresses from repository', () async {
      final repo = FakeAddressRepository(addresses: [sample1, sample2]);
      final useCase = GetAddressesUseCase(repo);

      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right'),
        (addresses) => expect(addresses, [sample1, sample2]),
      );
    });

    test('getCached retrieves cached addresses synchronously', () {
      final repo = FakeAddressRepository(addresses: [sample1]);
      final useCase = GetAddressesUseCase(repo);

      final result = useCase.getCached();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right'),
        (addresses) => expect(addresses, [sample1]),
      );
    });

    test('call propagates failure when repository fails', () async {
      final repo = FakeAddressRepository(
        failure: const Failure(message: 'Error fetching', type: FailureType.network),
      );
      final useCase = GetAddressesUseCase(repo);

      final result = await useCase();

      expect(result.isLeft(), isTrue);
    });
  });

  group('SaveAddressUseCase Tests', () {
    test('calls createAddress when id is null', () async {
      final repo = FakeAddressRepository();
      final useCase = SaveAddressUseCase(repo);

      const newAddress = AddressEntity(
        id: 10,
        street: '789 New Way',
        city: 'Dammam',
      );

      final result = await useCase(address: newAddress);

      expect(result.isRight(), isTrue);
      expect(repo.addresses, contains(newAddress));
    });

    test('calls updateAddress when id is provided', () async {
      final repo = FakeAddressRepository(addresses: [sample1]);
      final useCase = SaveAddressUseCase(repo);

      final updatedAddress = sample1.copyWith(street: 'Updated St');

      final result = await useCase(id: sample1.id, address: updatedAddress);

      expect(result.isRight(), isTrue);
      expect(repo.addresses.first.street, 'Updated St');
    });
  });

  group('DeleteAddressUseCase Tests', () {
    test('calls deleteAddress with specified id', () async {
      final repo = FakeAddressRepository(addresses: [sample1, sample2]);
      final useCase = DeleteAddressUseCase(repo);

      final result = await useCase(1);

      expect(result.isRight(), isTrue);
      expect(repo.addresses.length, 1);
      expect(repo.addresses.first.id, 2);
    });
  });

  group('SetDefaultAddressUseCase Tests', () {
    test('marks specified address as default and others as non-default', () async {
      final repo = FakeAddressRepository(addresses: [sample1, sample2]);
      final useCase = SetDefaultAddressUseCase(repo);

      final result = await useCase(2);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right'),
        (updatedDefault) => expect(updatedDefault.isDefault, isTrue),
      );

      expect(repo.addresses.firstWhere((a) => a.id == 1).isDefault, isFalse);
      expect(repo.addresses.firstWhere((a) => a.id == 2).isDefault, isTrue);
    });
  });
}
