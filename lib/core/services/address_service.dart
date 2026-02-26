import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/config/api_config.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddressService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  /// Get all addresses for the current user
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _apiService.get(ApiConfig.addresses);

      final data = response.data;
      final List<dynamic> addressesJson = data['addresses'] ?? [];

      return addressesJson
          .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'فشل تحميل العناوين';
    }
  }

  /// Create a new address
  Future<AddressModel> createAddress(AddressModel address) async {
    try {
      final Map<String, dynamic> addressData = address.toJson();

      _cleanAddressData(addressData);

      final response = await _apiService.post(
        ApiConfig.addresses,
        data: addressData,
      );

      final data = response.data;
      return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'فشل إضافة العنوان';
    }
  }

  /// Update an existing address
  Future<AddressModel> updateAddress(int id, AddressModel address) async {
    try {
      final Map<String, dynamic> addressData = address.toJson();
      _cleanAddressData(addressData);

      final response = await _apiService.put(
        '${ApiConfig.addresses}/$id',
        data: addressData,
      );

      final data = response.data;
      return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'فشل تحديث العنوان';
    }
  }

  /// Delete an address
  Future<void> deleteAddress(int id) async {
    try {
      await _apiService.delete('${ApiConfig.addresses}/$id');
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'فشل حذف العنوان';
    }
  }

  /// Set an address as default
  Future<AddressModel> setDefaultAddress(int id) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.addresses}/$id/set-default',
      );

      final data = response.data;
      return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'فشل تعيين العنوان الافتراضي';
    }
  }

  /// Helper to remove unnecessary fields before sending to API
  void _cleanAddressData(Map<String, dynamic> data) {
    data.removeWhere(
      (key, value) =>
          ['id', 'user_id', 'created_at', 'updated_at'].contains(key),
    );
  }


  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw 'خدمات الموقع معطلة. يرجى تفعيلها.';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'تم رفض صلاحيات الموقع';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'صلاحيات الموقع مرفوضة بشكل دائم.';
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<Placemark?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      return placemarks.isNotEmpty ? placemarks.first : null;
    } catch (e) {
      return null;
    }
  }
}
