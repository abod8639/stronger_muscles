import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:flutter/material.dart';

class AddressController extends GetxController {
  final AddressService _addressService = Get.find<AddressService>();
  
  // States
  final addresses = <AddressModel>[].obs;
  final isLoading = false.obs;
  final selectedLabel = 'Home'.obs;

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
      
      Get.snackbar('نجح', 'تم حذف العنوان بنجاح', 
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      _showError('فشل الحذف', e);
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

      Get.snackbar('نجح', 'تم تعيين العنوان كافتراضي', 
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      _showError('فشل التعيين كافتراضي', e);
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
      selectedLabel.value = 'Home';
      return;
    }
    fullNameController.text = address.fullName??'';
    phoneController.text = address.phone??'';
    streetController.text = address.street;
    cityController.text = address.city;
    stateController.text = address.state??'';
    postalCodeController.text = address.postalCode??'';
    countryController.text = address.country??'';
    selectedLabel.value = address.label??'Home';
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      final fetched = await _addressService.getAddresses();
      addresses.assignAll(fetched);
    } catch (e) {
      _showError('خطأ في جلب البيانات', e);
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
      Get.snackbar('نجح', 'تم حفظ العنوان بنجاح');
      clearForm();
    } catch (e) {
      _showError('خطأ في الحفظ', e);
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
        Get.snackbar('نجح', 'تم تحديد موقعك الحالي');
      }
    } catch (e) {
      _showError('فشل تحديد الموقع', e);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    [fullNameController, phoneController, streetController, cityController, 
     stateController, postalCodeController, countryController].forEach((c) => c.clear());
  }

  void _showError(String title, dynamic e) {
    Get.snackbar(title, e.toString(), 
      snackPosition: SnackPosition.BOTTOM, 
      backgroundColor: Colors.red.withOpacity(0.1));
  }
}