import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_service.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';

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
  FutureOr<List<AddressModel>> build() async {
    ref.onDispose(() {
      fullNameController.dispose();
      phoneController.dispose();
      streetController.dispose();
      cityController.dispose();
      stateController.dispose();
      postalCodeController.dispose();
      countryController.dispose();
    });

    final isLoggedIn = ref.watch(authControllerProvider.select((state) => state.value != null));
    final repository = ref.watch(addressRepositoryProvider);
    
    if (isLoggedIn) {
      final cached = repository.getCachedAddresses();
      if (cached.isNotEmpty) {
        return cached;
      }
      return await repository.getAddresses();
    }
    
    return [];
  }

  Future<void> fetchAddresses() async {
    state = const AsyncLoading();
    final repository = ref.read(addressRepositoryProvider);
    try {
      final fetched = await repository.getAddresses();
      state = AsyncData(fetched);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteAddress(int id) async {
    ref.read(addressFormLoadingProvider.notifier).setLoading(true);
    try {
      final repository = ref.read(addressRepositoryProvider);
      await repository.deleteAddress(id);
      final currentAddresses = state.value ?? [];
      state = AsyncData(
        currentAddresses.where((addr) => addr.id != id).toList(),
      );
    } finally {
      ref.read(addressFormLoadingProvider.notifier).setLoading(false);
    }
  }

  Future<void> setDefaultAddress(int id) async {
    ref.read(addressFormLoadingProvider.notifier).setLoading(true);
    try {
      final repository = ref.read(addressRepositoryProvider);
      await repository.setDefaultAddress(id);
      await fetchAddresses();
    } finally {
      ref.read(addressFormLoadingProvider.notifier).setLoading(false);
    }
  }

  AddressModel? get defaultAddress {
    final addresses = state.value ?? [];
    return addresses.where((addr) => addr.isDefault).firstOrNull ??
        (addresses.isNotEmpty ? addresses.first : null);
  }

  void fillForm(AddressModel? address) {
    if (address == null) {
      clearForm();
      ref.read(addressFormSelectedLabelProvider.notifier).setLabel(_defaultLabel);
      return;
    }
    fullNameController.text = address.fullName ?? '';
    phoneController.text = address.phone ?? '';
    streetController.text = address.street;
    cityController.text = address.city;
    stateController.text = address.state ?? '';
    postalCodeController.text = address.postalCode ?? '';
    countryController.text = address.country ?? '';
    ref.read(addressFormSelectedLabelProvider.notifier).setLabel(address.label ?? _defaultLabel);
    _latitude = address.latitude;
    _longitude = address.longitude;
  }

  Future<void> saveAddress(int? id) async {
    final model = AddressModel(
      id: id ?? 0,
      fullName: fullNameController.text,
      phone: phoneController.text,
      street: streetController.text,
      city: cityController.text,
      state: stateController.text,
      postalCode: postalCodeController.text,
      country: countryController.text,
      label: ref.read(addressFormSelectedLabelProvider),
      isDefault: false,
      latitude: _latitude,
      longitude: _longitude,
    );

    ref.read(addressFormLoadingProvider.notifier).setLoading(true);
    try {
      final repository = ref.read(addressRepositoryProvider);
      if (id == null) {
        await repository.createAddress(model);
      } else {
        await repository.updateAddress(id, model);
      }
      await fetchAddresses();
      clearForm();
    } finally {
      ref.read(addressFormLoadingProvider.notifier).setLoading(false);
    }
  }

  Future<void> getCurrentLocation() async {
    ref.read(addressFormLoadingProvider.notifier).setLoading(true);
    try {
      final service = ref.read(addressServiceProvider);
      final position = await service.getCurrentPosition();
      final place = await service.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (place != null) {
        streetController.text = place.street ?? '';
        cityController.text = place.locality ?? '';
        stateController.text = place.administrativeArea ?? '';
        postalCodeController.text = place.postalCode ?? '';
        countryController.text = place.country ?? '';
        _latitude = position.latitude;
        _longitude = position.longitude;
      }
    } finally {
      ref.read(addressFormLoadingProvider.notifier).setLoading(false);
    }
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
