import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class AddressController extends GetxController {
  final AddressService _addressService = Get.find<AddressService>();
  final RxList<AddressModel> addresses = RxList<AddressModel>([]);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isDefault = false.obs;

  // Controllers for the add address form
  final Rx<TextEditingController> streetController = TextEditingController().obs;
  final Rx<TextEditingController> cityController = TextEditingController().obs;
  final Rx<TextEditingController> stateController = TextEditingController().obs;
  final Rx<TextEditingController> postalCodeController = TextEditingController().obs;
  final Rx<TextEditingController> countryController = TextEditingController().obs;
  final Rx<TextEditingController> fullNameController = TextEditingController().obs;
  final Rx<TextEditingController> phoneNumberController = TextEditingController().obs;

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
    fullNameController.value.dispose();
    phoneNumberController.value.dispose();
    super.onClose();
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedAddresses = await _addressService.getAddresses();
      addresses.assignAll(fetchedAddresses);

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

      // نرسل الطلب للخادم
      await _addressService.createAddress(address);

      // بدلاً من محاولة إضافة العنصر يدوياً للقائمة المحلية (والتي قد تكون Locked)
      // نقوم بإعادة جلب العناوين من السيرفر لضمان المزامنة الصحيحة 100%
      await fetchAddresses();

      Get.back();
      Get.snackbar('نجح', 'تم إضافة العنوان بنجاح');
      clearForm();
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ خطأ في إضافة العنوان: $e');
      Get.snackbar('خطأ', 'فشل إضافة العنوان. تأكد من صحة البيانات.');
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
      isLoading.value = true;

      // Call the dedicated set-default endpoint
      final updatedAddress = await _addressService.setDefaultAddress(id);

      // Update local state
      final tempAddresses = addresses.map((e) {
        if (e.id == id) {
          return updatedAddress;
        } else {
          return e.copyWith(isDefault: false);
        }
      }).toList();

      addresses.assignAll(tempAddresses);

      print('✅ تم تعيين العنوان الافتراضي');
      Get.snackbar('نجح', 'تم تعيين العنوان الافتراضي بنجاح');
    } catch (e) {
      print('❌ خطأ في تعيين العنوان الافتراضي: $e');
      Get.snackbar('خطأ', 'فشل تعيين العنوان الافتراضي');
      // Rollback - refetch from server
      await fetchAddresses();
    } finally {
      isLoading.value = false;
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
        position.longitude,
      );

      if (place != null) {
        // Fill the observable controllers
        fullNameController.value.text = place.name ?? '';
        // phoneNumberController.value.text = place.phone ?? '';
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
      Get.snackbar(
        'خطأ',
        'فشل تحديد الموقع: $e. تأكد من تفعيل خدمات الموقع وإعطاء الصلاحيات.',
      );
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
    fullNameController.value.clear();
    phoneNumberController.value.clear();
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
