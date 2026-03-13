import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_service.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';

part 'address_controller.g.dart';

const String _defaultLabel = 'Home';

@riverpod
class AddressController extends _$AddressController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();
  
  String _selectedLabel = _defaultLabel;
  String get selectedLabel => _selectedLabel;
  set selectedLabel(String val) {
    _selectedLabel = val;
    ref.notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
    
    final repository = ref.watch(addressRepositoryProvider);
    return repository.getCachedAddresses();
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
    _isLoading = true;
    ref.notifyListeners();
    try {
      final repository = ref.read(addressRepositoryProvider);
      await repository.deleteAddress(id);
      final currentAddresses = state.value ?? [];
      state = AsyncData(currentAddresses.where((addr) => addr.id != id).toList());
    } finally {
      _isLoading = false;
      ref.notifyListeners();
    }
  }

  Future<void> setDefaultAddress(int id) async {
    _isLoading = true;
    ref.notifyListeners();
    try {
      final repository = ref.read(addressRepositoryProvider);
      await repository.setDefaultAddress(id);
      await fetchAddresses();
    } finally {
      _isLoading = false;
      ref.notifyListeners();
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
      _selectedLabel = _defaultLabel;
      ref.notifyListeners();
      return;
    }
    fullNameController.text = address.fullName ?? '';
    phoneController.text = address.phone ?? '';
    streetController.text = address.street;
    cityController.text = address.city;
    stateController.text = address.state ?? '';
    postalCodeController.text = address.postalCode ?? '';
    countryController.text = address.country ?? '';
    _selectedLabel = address.label ?? _defaultLabel;
    ref.notifyListeners();
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
      label: _selectedLabel,
      isDefault: false,
    );

    _isLoading = true;
    ref.notifyListeners();
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
      _isLoading = false;
      ref.notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    ref.notifyListeners();
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
      }
    } finally {
      _isLoading = false;
      ref.notifyListeners();
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
  }
}
