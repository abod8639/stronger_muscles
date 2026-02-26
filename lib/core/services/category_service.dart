import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../config/api_config.dart';
import '../../data/models/category_model.dart';

class CategoryService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<CategoryModel>> fetchCategoriesFromApi() async {
    try {
      final response = await _apiService.get(ApiConfig.categories);
      
      return _parseCategories(response.data);
    } catch (e) {
      rethrow;
    }
  }

  List<CategoryModel> _parseCategories(dynamic decodedData) {
    List<dynamic> list = [];
    
    if (decodedData is List) {
      list = decodedData;
    } else if (decodedData is Map) {
      // التعامل مع Laravel API Resource (data wrap)
      var data = decodedData['data'];
      if (data is List) {
        list = data;
      }
    }
    
    return list.map((json) => CategoryModel.fromJson(json)).toList();
  }
}