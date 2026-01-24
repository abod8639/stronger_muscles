import 'dart:convert';
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
      final response = await _apiService.get(ApiConfig.addresses );
      print('📍 Get Addresses Response: ${response.body}');

      final body = jsonDecode(response.body);
      final List<dynamic> addressesJson = body['addresses'] ?? [];

      return addressesJson
          .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on Failure catch (e) {
      print('❌ Get Addresses API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Get Addresses Error: $e');
      throw 'فشل تحميل العناوين: ${e.toString()}';
    }
  }

  /// Create a new address
  Future<AddressModel> createAddress(AddressModel address) async {
    try {
      final addressData = address.toJson();
      // Remove id for new addresses
      addressData.remove('id');
      addressData.remove('user_id');
      addressData.remove('created_at');
      addressData.remove('updated_at');

      final response = await _apiService.post(
        '/customer/addresses',
        data: addressData,
      );

      print('📍 Create Address Response: ${response.body}');

      final body = jsonDecode(response.body);
      return AddressModel.fromJson(body['address'] as Map<String, dynamic>);
    } on Failure catch (e) {
      print('❌ Create Address API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Create Address Error: $e');
      throw 'فشل إضافة العنوان: ${e.toString()}';
    }
  }

  /// Update an existing address
  Future<AddressModel> updateAddress(int id, AddressModel address) async {
    try {
      final addressData = address.toJson();
      // Clean up fields that shouldn't be sent
      addressData.remove('id');
      addressData.remove('user_id');
      addressData.remove('created_at');
      addressData.remove('updated_at');

      final response = await _apiService.put(
        '/customer/addresses/$id',
        data: addressData,
      );

      print('📍 Update Address Response: ${response.body}');

      final body = jsonDecode(response.body);
      return AddressModel.fromJson(body['address'] as Map<String, dynamic>);
    } on Failure catch (e) {
      print('❌ Update Address API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Update Address Error: $e');
      throw 'فشل تحديث العنوان: ${e.toString()}';
    }
  }

  /// Delete an address
  Future<void> deleteAddress(int id) async {
    try {
      final response = await _apiService.delete('/customer/addresses/$id');
      print('📍 Delete Address Response: ${response.body}');
    } on Failure catch (e) {
      print('❌ Delete Address API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Delete Address Error: $e');
      throw 'فشل حذف العنوان: ${e.toString()}';
    }
  }

  /// Set an address as default
  Future<AddressModel> setDefaultAddress(int id) async {
    try {
      final response = await _apiService.post('/customer/addresses/$id/set-default');
      print('📍 Set Default Address Response: ${response.body}');

      final body = jsonDecode(response.body);
      return AddressModel.fromJson(body['address'] as Map<String, dynamic>);
    } on Failure catch (e) {
      print('❌ Set Default Address API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Set Default Address Error: $e');
      throw 'فشل تعيين العنوان الافتراضي: ${e.toString()}';
    }
  }

  /// Get current GPS position
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'خدمات الموقع معطلة. يرجى تفعيلها.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'تم رفض صلاحيات الموقع';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'صلاحيات الموقع مرفوضة بشكل دائم. يرجى تفعيلها من الإعدادات.';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Get address from coordinates using geocoding
  Future<Placemark?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks.first;
      }
      return null;
    } catch (e) {
      print('❌ Geocoding Error: $e');
      return null;
    }
  }
}
