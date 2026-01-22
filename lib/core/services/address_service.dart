import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/core/services/auth_service.dart';

class AddressService extends GetxService {
  final AuthService _authService = Get.find<AuthService>();

  // --- Address Management via AuthService ---

  Future<List<AddressModel>> getAddresses() async {
    try {
      final user = await _authService.getCurrentUser();
      return List<AddressModel>.from(user?.addresses ?? []);
    } catch (e) {
      print('Error fetching addresses: $e');
      return [];
    }
  }

  Future<AddressModel> createAddress(AddressModel address) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw Exception('يرجى تسجيل الدخول أولاً لإضافة عنوان');

      // نأخذ نسخة جديدة وقابلة للتعديل تماماً من القائمة الحالية
      final List<AddressModel> currentAddresses = List<AddressModel>.from(user.addresses ?? []);
      
      // نجهز العنوان الجديد مع معرف مؤقت
      final newAddress = address.copyWith(
        id: address.id == 0 ? DateTime.now().millisecondsSinceEpoch : address.id
      );
      
      currentAddresses.add(newAddress);

      // نرسل القائمة كاملة للتحديث
      final updatedUser = await _authService.updateProfile(addresses: currentAddresses);
      
      // نعيد العنوان الأحدث من الرد
      return updatedUser.addresses?.last ?? newAddress;
    } catch (e) {
      print('❌ Error in createAddress: $e');
      rethrow;
    }
  }

  Future<AddressModel> updateAddress(int id, AddressModel address) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw Exception('User not found');

      List<AddressModel> currentAddresses = List.from(user.addresses ?? []);
      
      final index = currentAddresses.indexWhere((a) => a.id == id);
      if (index != -1) {
        currentAddresses[index] = address;
        final updatedUser = await _authService.updateProfile(addresses: currentAddresses);
         return updatedUser.addresses?.firstWhere((a) => a.id == id, orElse: () => address) ?? address;
      } else {
        throw Exception('Address not found');
      }
    } catch (e) {
      print('Error updating address: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw Exception('User not found');

      List<AddressModel> currentAddresses = List.from(user.addresses ?? []);
      currentAddresses.removeWhere((a) => a.id == id);

      await _authService.updateProfile(addresses: currentAddresses);
    } catch (e) {
      print('Error deleting address: $e');
      rethrow;
    }
  }

  // --- Geolocation Methods ---

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition();
  }

  Future<Placemark?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first;
      }
      return null;
    } catch (e) {
      print('Error getting address from coordinates: $e');
      return null;
    }
  }

}
