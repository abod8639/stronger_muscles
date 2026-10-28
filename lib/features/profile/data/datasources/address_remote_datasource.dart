import 'package:fpdart/fpdart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';

/// Contract for remote address operations via Dio.
abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> createAddress(AddressModel address);
  Future<AddressModel> updateAddress(int id, AddressModel address);
  Future<void> deleteAddress(int id);
  Future<AddressModel> setDefaultAddress(int id);
  Future<Either<Failure, Position>> getCurrentPosition();
  Future<Either<Failure, Placemark?>> getAddressFromCoordinates(
    double lat,
    double lng,
  );
}

/// Dio-backed implementation of [AddressRemoteDataSource].
class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiService _apiService;

  AddressRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await _apiService.get(ApiConfig.addresses);
    final data = response.data;
    final List<dynamic> addressesJson = data['addresses'] ?? [];
    return addressesJson
        .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AddressModel> createAddress(AddressModel address) async {
    final Map<String, dynamic> addressData = address.toJson();
    _cleanAddressData(addressData);
    final response = await _apiService.post(
      ApiConfig.addresses,
      data: addressData,
    );
    final data = response.data;
    return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
  }

  @override
  Future<AddressModel> updateAddress(int id, AddressModel address) async {
    final Map<String, dynamic> addressData = address.toJson();
    _cleanAddressData(addressData);
    final response = await _apiService.put(
      '${ApiConfig.addresses}/$id',
      data: addressData,
    );
    final data = response.data;
    return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteAddress(int id) async {
    await _apiService.delete('${ApiConfig.addresses}/$id');
  }

  @override
  Future<AddressModel> setDefaultAddress(int id) async {
    final response = await _apiService.post(
      '${ApiConfig.addresses}/$id/set-default',
    );
    final data = response.data;
    return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
  }

  void _cleanAddressData(Map<String, dynamic> data) {
    data.removeWhere(
      (key, value) =>
          ['id', 'user_id', 'created_at', 'updated_at'].contains(key),
    );
  }

  @override
  Future<Either<Failure, Position>> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(Failure(message: 'خدمات الموقع معطلة. يرجى تفعيلها.'));
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(Failure(message: 'تم رفض صلاحيات الموقع'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(Failure(message: 'صلاحيات الموقع مرفوضة بشكل دائم.'));
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );
      return Right(position);
    } catch (e, st) {
      return Left(
        UnknownFailure(
          message: 'فشل تحديد الموقع الحالي',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Placemark?>> getAddressFromCoordinates(
    double lat,
    double lng,
  ) async {
    try {
      List<Placemark> placemarks =
          await Geocoding().placemarkFromCoordinates(lat, lng);
      return Right(placemarks.isNotEmpty ? placemarks.first : null);
    } catch (e, st) {
      return Left(
        UnknownFailure(
          message: 'فشل استرجاع تفاصيل العنوان من الإحداثيات',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }
}
