import 'dart:convert';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../config/api_config.dart';
import '../../data/models/category_model.dart';

class CategoryService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<CategoryModel>> fetchCategoriesFromApi() async {
    final response = await _apiService.get(ApiConfig.categories);
    final dynamic decodedData = jsonDecode(response.body);

    return _parseCategories(decodedData);
  }

  List<CategoryModel> _parseCategories(dynamic decodedData) {
    List<dynamic> list = [];
    if (decodedData is List) {
      list = decodedData;
    } else if (decodedData is Map) {
      list = decodedData['data'] ?? [];
      // التعامل مع nested data من Laravel Resource
      list = decodedData['data'] is List ? decodedData['data'] : [];
    }
    return list.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
