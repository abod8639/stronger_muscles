import 'dart:convert';
import 'package:get/get.dart';
import '../../config/api_config.dart';
import '../../data/models/address_model.dart';
import '../errors/failures.dart';
import 'api_service.dart';

class AddressService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _apiService.get(ApiConfig.addresses);
      final body = jsonDecode(response.body);
      
      // Handle both array and object with 'data' key
      final List<dynamic> addressesJson = body is List ? body : body['data'];
      
      return addressesJson
          .map((json) => AddressModel.fromJson(json))
          .toList();
    } on Failure {
      rethrow;
    } catch (e) {
      print('❌ Get Addresses Error: $e');
      throw e.toString();
    }
  }

  Future<AddressModel> createAddress(AddressModel address) async {
    try {
      final response = await _apiService.post(
        ApiConfig.orders,
        data: address.toJson(),
      );
      
      final body = jsonDecode(response.body);
      return AddressModel.fromJson(body['data'] ?? body);
    } on Failure {
      rethrow;
    } catch (e) {
      print('❌ Create Address Error: $e');
      throw e.toString();
    }
  }

  Future<AddressModel> updateAddress(int id, AddressModel address) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.addresses}/$id',
        data: address.toJson(),
      );
      
      final body = jsonDecode(response.body);
      return AddressModel.fromJson(body['data'] ?? body);
    } on Failure {
      rethrow;
    } catch (e) {
      print('❌ Update Address Error: $e');
      throw e.toString();
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      await _apiService.delete('${ApiConfig.addresses}/$id');
    } on Failure {
      rethrow;
    } catch (e) {
      print('❌ Delete Address Error: $e');
      throw e.toString();
    }
  }
}
