import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/profile_providers.dart';

part 'address_controller.g.dart';

const String _defaultLabel = 'Home';

@riverpod
class AddressFormLoading extends _$AddressFormLoading {
  @override
  bool build() => false;

  void setLoading(bool val) => state = val;
}

@riverpod
class AddressFormSelectedLabel extends _$AddressFormSelectedLabel {
  @override
  String build() => _defaultLabel;

  void setLabel(String val) => state = val;
}

@riverpod
class AddressController extends _$AddressController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();

  String get selectedLabel => ref.read(addressFormSelectedLabelProvider);
  set selectedLabel(String val) {
    ref.read(addressFormSelectedLabelProvider.notifier).setLabel(val);
  }

  double? _latitude;
  double? _longitude;

  bool get isLoading => ref.read(addressFormLoadingProvider);

  @override
  FutureOr<List<AddressEntity>> build() async {
    final isLoggedIn = ref.watch(
      authControllerProvider.select((state) => state.valueOrNull != null),
    );
    final getAddressesUseCase = ref.watch(getAddressesUseCaseProvider);

    if (isLoggedIn) {
      final cachedResult = getAddressesUseCase.getCached();
      final cached = cachedResult.fold((_) => <AddressEntity>[], (list) => list);
      if (cached.isNotEmpty) {
        return cached;
      }
      final result = await getAddressesUseCase();
      return result.fold(
        (failure) => throw failure,
        (addresses) => addresses,
      );
    }

    return [];
  }

  Future<void> fetchAddresses() async {
    // Avoid wiping the existing list with AsyncLoading — keep data visible
    // and only replace it when the new result arrives.
    final getAddressesUseCase = ref.read(getAddressesUseCaseProvider);
    final result = await getAddressesUseCase();
    result.fold(
      (failure) => state = AsyncError(
        failure,
        failure.stackTrace ?? StackTrace.current,
      ),
      (addresses) => state = AsyncData(addresses),
    );
  }

  Future<void> deleteAddress(int id) async {
    ref.read(addressFormLoadingProvider.notifier).setLoading(true);
    final result = await ref.read(deleteAddressUseCaseProvider).call(id);
    ref.read(addressFormLoadingProvider.notifier).setLoading(false);
    result.fold(
      (failure) => state = AsyncError(
        failure,
        failure.stackTrace ?? StackTrace.current,
      ),
      (_) {
        final currentAddresses = state.valueOrNull ?? [];
        state = AsyncData(
          currentAddresses.where((addr) => addr.id != id).toList(),
        );
      },
    );
  }

  Future<void> setDefaultAddress(int id) async {
    ref.read(addressFormLoadingProvider.notifier).setLoading(true);
    final result = await ref.read(setDefaultAddressUseCaseProvider).call(id);
    ref.read(addressFormLoadingProvider.notifier).setLoading(false);
    result.fold(
      (failure) => state = AsyncError(
        failure,
        failure.stackTrace ?? StackTrace.current,
      ),
      (_) async {
        await fetchAddresses();
      },
    );
  }

  AddressEntity? get defaultAddress {
    final addresses = state.valueOrNull ?? [];
    return addresses.where((addr) => addr.isDefault).firstOrNull ??
        (addresses.isNotEmpty ? addresses.first : null);
  }

  void fillForm(AddressEntity? address) {
    if (address == null) {
      clearForm();
      ref
          .read(addressFormSelectedLabelProvider.notifier)
          .setLabel(_defaultLabel);
      return;
    }
    fullNameController.text = address.fullName ?? '';
    phoneController.text = address.phone ?? '';
    streetController.text = address.street;
    cityController.text = address.city;
    stateController.text = address.state ?? '';
    postalCodeController.text = address.postalCode ?? '';
    countryController.text = address.country ?? '';
    ref
        .read(addressFormSelectedLabelProvider.notifier)
        .setLabel(address.label ?? _defaultLabel);
    _latitude = address.latitude;
    _longitude = address.longitude;
  }

  Future<void> saveAddressEntity({
    int? id,
    required AddressEntity address,
  }) async {
    ref.read(addressFormLoadingProvider.notifier).setLoading(true);
    final result = await ref.read(saveAddressUseCaseProvider).call(
      id: id,
      address: address,
    );
    ref.read(addressFormLoadingProvider.notifier).setLoading(false);
    result.fold(
      (failure) => state = AsyncError(
        failure,
        failure.stackTrace ?? StackTrace.current,
      ),
      (_) async {
        await fetchAddresses();
        clearForm();
      },
    );
  }

  Future<void> saveAddress(int? id) async {
    final entity = AddressEntity(
      id: id ?? 0,
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      street: streetController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      postalCode: postalCodeController.text.trim(),
      country: countryController.text.trim(),
      label: ref.read(addressFormSelectedLabelProvider),
      isDefault: false,
      latitude: _latitude,
      longitude: _longitude,
    );

    await saveAddressEntity(id: id, address: entity);
  }

  Future<Map<String, dynamic>?> getCurrentLocationData() async {
    ref.read(addressFormLoadingProvider.notifier).setLoading(true);
    try {
      final remoteDataSource = ref.read(addressRemoteDataSourceProvider);
      final positionResult = await remoteDataSource.getCurrentPosition();
      return await positionResult.fold(
        (failure) async {
          ref.read(addressFormLoadingProvider.notifier).setLoading(false);
          return null;
        },
        (position) async {
          _latitude = position.latitude;
          _longitude = position.longitude;
          final placeResult = await remoteDataSource.getAddressFromCoordinates(
            position.latitude,
            position.longitude,
          );
          ref.read(addressFormLoadingProvider.notifier).setLoading(false);
          final data = placeResult.fold(
            (failure) => <String, dynamic>{
              'latitude': position.latitude,
              'longitude': position.longitude,
            },
            (place) => <String, dynamic>{
              'latitude': position.latitude,
              'longitude': position.longitude,
              'street': place?.street ?? '',
              'city': place?.locality ?? '',
              'state': place?.administrativeArea ?? '',
              'postalCode': place?.postalCode ?? '',
              'country': place?.country ?? '',
            },
          );
          if (data['street'] != null) streetController.text = data['street'] as String;
          if (data['city'] != null) cityController.text = data['city'] as String;
          if (data['state'] != null) stateController.text = data['state'] as String;
          if (data['postalCode'] != null) postalCodeController.text = data['postalCode'] as String;
          if (data['country'] != null) countryController.text = data['country'] as String;
          return data;
        },
      );
    } catch (_) {
      ref.read(addressFormLoadingProvider.notifier).setLoading(false);
      return null;
    }
  }

  Future<void> getCurrentLocation() async {
    await getCurrentLocationData();
  }

  void clearForm() {
    for (var c in [
      fullNameController,
      phoneController,
      streetController,
      cityController,
      stateController,
      postalCodeController,
      countryController,
    ]) {
      c.clear();
    }
    _latitude = null;
    _longitude = null;
  }
}
