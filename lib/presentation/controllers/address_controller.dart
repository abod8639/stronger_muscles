import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:flutter/material.dart';

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

class AddressController extends GetxController {
  final AddressService _addressService = Get.find<AddressService>();
  
  // States
  final addresses = <AddressModel>[].obs;
  final isLoading = false.obs;
  final selectedLabel = _defaultLabel.obs;

  // توحيد المتحكمات في مكان واحد
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
    fetchAddresses();
  }

  @override
  void onClose() {
    // التخلص من المتحكمات بشكل صحيح
    for (var controller in [
      fullNameController, phoneController, streetController,
      cityController, stateController, postalCodeController, countryController
    ]) {
      controller.dispose();
    }
    super.onClose();
  }


  Future<void> deleteAddress(int id) async {
    try {
      isLoading.value = true;
      await _addressService.deleteAddress(id);
      
      // تحديث القائمة محلياً فوراً لتحسين استجابة الواجهة
      addresses.removeWhere((addr) => addr.id == id);
      
      Get.snackbar(_successTitle, _successDeleteMsg, 
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      _showError(_errorDeleteMsg, e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setDefaultAddress(int id) async {
    try {
      isLoading.value = true;
      
      final updatedAddress = await _addressService.setDefaultAddress(id);

      addresses.assignAll(addresses.map((addr) {
        if (addr.id == id) {
          return updatedAddress; 
        } else {
          return addr.copyWith(isDefault: false); 
        }
      }).toList());

      Get.snackbar(_successTitle, _successDefaultMsg, 
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      _showError(_errorDefaultMsg, e);
      await fetchAddresses();
    } finally {
      isLoading.value = false;
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
    fullNameController.text = address.fullName??'';
    phoneController.text = address.phone??'';
    streetController.text = address.street;
    cityController.text = address.city;
    stateController.text = address.state??'';
    postalCodeController.text = address.postalCode??'';
    countryController.text = address.country??'';
    selectedLabel.value = address.label??_defaultLabel;
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      final fetched = await _addressService.getAddresses();
      addresses.assignAll(fetched);
    } catch (e) {
      _showError(_errorFetchMsg, e);
    } finally {
      isLoading.value = false;
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
      isLoading.value = true;
      if (id == null) {
        await _addressService.createAddress(model);
      } else {
        await _addressService.updateAddress(id, model);
      }
      await fetchAddresses();
      Get.back();
      Get.snackbar(_successTitle, _successSaveMsg);
      clearForm();
    } catch (e) {
      _showError(_errorSaveMsg, e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      final position = await _addressService.getCurrentPosition();
      final place = await _addressService.getAddressFromCoordinates(
        position.latitude, position.longitude,
      );

      if (place != null) {
        streetController.text = place.street ?? '';
        cityController.text = place.locality ?? '';
        stateController.text = place.administrativeArea ?? '';
        postalCodeController.text = place.postalCode ?? '';
        countryController.text = place.country ?? '';
        Get.snackbar(_successTitle, _successLocationMsg);
      }
    } catch (e) {
      _showError(_errorLocationMsg, e);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    for (var c in [fullNameController, phoneController, streetController, cityController, 
     stateController, postalCodeController, countryController]) {
      c.clear();
    }
  }

  void _showError(String title, dynamic e) {
    Get.snackbar(title, e.toString(), 
      snackPosition: SnackPosition.BOTTOM, 
      backgroundColor: Colors.red.withOpacity(0.1));
  }
}