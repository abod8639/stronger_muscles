import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class AddressController extends GetxController {
  final AddressService _addressService = Get.put(AddressService());
  // final UserModel _userModel = Get.put(UserModel());
  final RxList<AddressModel> addresses = RxList<AddressModel>([]);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Controllers for the add address form
  final Rx<TextEditingController> streetController = TextEditingController().obs;
  final Rx<TextEditingController> cityController = TextEditingController().obs;
  final Rx<TextEditingController> stateController = TextEditingController().obs;
  final Rx<TextEditingController> postalCodeController = TextEditingController().obs;
  final Rx<TextEditingController> countryController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  @override
  void onClose() {
    streetController.value.dispose();
    cityController.value.dispose();
    stateController.value.dispose();
    postalCodeController.value.dispose();
    countryController.value.dispose();
    super.onClose();
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final fetchedAddresses = await _addressService.getAddresses();
      addresses.value = fetchedAddresses;
      
      print('✅ تم جلب ${addresses.length} عنوان');
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ خطأ في جلب العناوين: $e');
      // Get.snackbar('خطأ', 'فشل تحميل العناوين: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAddress(AddressModel address) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final newAddress = await _addressService.createAddress(address);
      addresses.add(newAddress);
      
      Get.back(); // Close dialog/form
      Get.snackbar('نجح', 'تم إضافة العنوان بنجاح');
      print('✅ تم إضافة عنوان جديد');
      
      // Clear form
      clearForm();
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ خطأ في إضافة العنوان: $e');
      Get.snackbar('خطأ', 'فشل إضافة العنوان: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(int id, AddressModel address) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final updatedAddress = await _addressService.updateAddress(id, address);
      
      final index = addresses.indexWhere((addr) => addr.id == id);
      if (index != -1) {
        addresses[index] = updatedAddress;
      }
      
      Get.back(); // Close dialog/form
      Get.snackbar('نجح', 'تم تحديث العنوان بنجاح');
      print('✅ تم تحديث العنوان');
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ خطأ في تحديث العنوان: $e');
      Get.snackbar('خطأ', 'فشل تحديث العنوان');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _addressService.deleteAddress(id);
      addresses.removeWhere((addr) => addr.id == id);
      
      Get.snackbar('نجح', 'تم حذف العنوان بنجاح');
      print('✅ تم حذف العنوان');
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ خطأ في حذف العنوان: $e');
      Get.snackbar('خطأ', 'فشل حذف العنوان');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setDefaultAddress(int id) async {
    try {
      // First, unset all default addresses in local state optimistically
      final tempAddresses = addresses.map((e) => e.copyWith(isDefault: false)).toList();
      addresses.value = tempAddresses; 
      
      final address = addresses.firstWhere((addr) => addr.id == id);
      final updatedAddress = address.copyWith(isDefault: true);
      
      // Call update
      await updateAddress(id, updatedAddress);
      
      // Refetch to sync state correctly (safest)
      await fetchAddresses();

      print('✅ تم تعيين العنوان الافتراضي');
    } catch (e) {
      print('❌ خطأ في تعيين العنوان الافتراضي: $e');
      Get.snackbar('خطأ', 'فشل تعيين العنوان الافتراضي');
    }
  }

  AddressModel? get defaultAddress {
    try {
      return addresses.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      final position = await _addressService.getCurrentPosition();
      
      final Placemark? place = await _addressService.getAddressFromCoordinates(
        position.latitude, 
        position.longitude
      );

      if (place != null) {
        // Fill the observable controllers
        streetController.value.text = place.street ?? '';
        cityController.value.text = place.locality ?? '';
        stateController.value.text = place.administrativeArea ?? '';
        postalCodeController.value.text = place.postalCode ?? '';
        countryController.value.text = place.country ?? '';
        
        Get.snackbar('نجح', 'تم تحديد الموقع بنجاح');
      } else {
        Get.snackbar('تنبيه', 'لم يتم العثور على عنوان لهذا الموقع');
      }

    } catch (e) {
      print('Error getting location: $e');
      Get.snackbar('خطأ', 'فشل تحديد الموقع: $e. تأكد من تفعيل خدمات الموقع وإعطاء الصلاحيات.');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    streetController.value.clear();
    cityController.value.clear();
    stateController.value.clear();
    postalCodeController.value.clear();
    countryController.value.clear();
  }

  String? validateStreet(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الشارع';
    }
    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال المدينة';
    }
    return null;
  }
}
