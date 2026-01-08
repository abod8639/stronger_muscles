import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/core/services/address_service.dart';

class AddressController extends GetxController {
  final AddressService _addressService = Get.put(AddressService());

  final RxList<AddressModel> addresses = RxList<AddressModel>([]);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
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
      Get.snackbar('خطأ', 'فشل تحميل العناوين');
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
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ خطأ في إضافة العنوان: $e');
      Get.snackbar('خطأ', 'فشل إضافة العنوان');
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
      // First, unset all default addresses
      for (var addr in addresses) {
        if (addr.isDefault) {
          final updated = addr.copyWith(isDefault: false);
          await _addressService.updateAddress(addr.id, updated);
        }
      }
      
      // Then set the new default
      final address = addresses.firstWhere((addr) => addr.id == id);
      final updatedAddress = address.copyWith(isDefault: true);
      await updateAddress(id, updatedAddress);
      
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
