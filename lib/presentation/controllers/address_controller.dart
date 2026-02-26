import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/data/repositories/address_repository.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:flutter/material.dart';
import 'base_controller.dart';

const String _defaultLabel = 'Home';
const String _successDeleteMsg = 'تم حذف العنوان بنجاح';
const String _errorDeleteMsg = 'فشل الحذف';
const String _successDefaultMsg = 'تم تعيين العنوان كافتراضي';
const String _errorDefaultMsg = 'فشل التعيين كافتراضي';
const String _errorFetchMsg = 'خطأ في جلب البيانات';
const String _successSaveMsg = 'تم حفظ العنوان بنجاح';
const String _errorSaveMsg = 'خطأ في الحفظ';
const String _successLocationMsg = 'تم تحديد موقعك الحالي';
const String _errorLocationMsg = 'فشل تحديد الموقع';
const String _successTitle = 'نجح';

class AddressController extends BaseController {
  final AddressRepository _repository = Get.find<AddressRepository>();
  final AddressService _addressService = Get.find<AddressService>();

  // States
  final addresses = <AddressModel>[].obs;
  final selectedLabel = _defaultLabel.obs;

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    addresses.assignAll(_repository.getCachedAddresses());
    // Lazy loading: addresses will be fetched when needed (e.g., when Profile or Checkout view is opened)
  }

  Future<void> deleteAddress(int id) async {
    try {
      setLoading(true);
      await _repository.deleteAddress(id);
      addresses.removeWhere((addr) => addr.id == id);
      showSuccessSnackbar(title: _successTitle, message: _successDeleteMsg);
    } catch (e) {
      handleError(e, title: _errorDeleteMsg);
    } finally {
      setLoading(false);
    }
  }

  Future<void> setDefaultAddress(int id) async {
    try {
      setLoading(true);
      await _repository.setDefaultAddress(id);
      await fetchAddresses();
      showSuccessSnackbar(title: _successTitle, message: _successDefaultMsg);
    } catch (e) {
      handleError(e, title: _errorDefaultMsg);
    } finally {
      setLoading(false);
    }
  }

  AddressModel? get defaultAddress =>
      addresses.firstWhereOrNull((addr) => addr.isDefault) ??
      (addresses.isNotEmpty ? addresses.first : null);

  void fillForm(AddressModel? address) {
    if (address == null) {
      clearForm();
      selectedLabel.value = _defaultLabel;
      return;
    }
    fullNameController.text = address.fullName ?? '';
    phoneController.text = address.phone ?? '';
    streetController.text = address.street;
    cityController.text = address.city;
    stateController.text = address.state ?? '';
    postalCodeController.text = address.postalCode ?? '';
    countryController.text = address.country ?? '';
    selectedLabel.value = address.label ?? _defaultLabel;
  }

  Future<void> fetchAddresses() async {
    if (isLoading.value) return;

    try {
      setLoading(true);
      final fetched = await _repository.getAddresses();
      addresses.assignAll(fetched);
    } catch (e) {
      handleError(e, title: _errorFetchMsg);
    } finally {
      setLoading(false);
    }
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
      label: selectedLabel.value,
      isDefault: false,
    );

    try {
      setLoading(true);
      if (id == null) {
        await _repository.createAddress(model);
      } else {
        await _repository.updateAddress(id, model);
      }
      await fetchAddresses();
      Get.back();
      showSuccessSnackbar(title: _successTitle, message: _successSaveMsg);
      clearForm();
    } catch (e) {
      handleError(e, title: _errorSaveMsg);
    } finally {
      setLoading(false);
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      setLoading(true);
      final position = await _addressService.getCurrentPosition();
      final place = await _addressService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (place != null) {
        streetController.text = place.street ?? '';
        cityController.text = place.locality ?? '';
        stateController.text = place.administrativeArea ?? '';
        postalCodeController.text = place.postalCode ?? '';
        countryController.text = place.country ?? '';
        showSuccessSnackbar(title: _successTitle, message: _successLocationMsg);
      }
    } catch (e) {
      handleError(e, title: _errorLocationMsg);
    } finally {
      setLoading(false);
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
