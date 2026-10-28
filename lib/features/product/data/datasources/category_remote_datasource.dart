import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiService _apiService;

  CategoryRemoteDataSource(this._apiService);

  Future<List<CategoryModel>> fetchCategoriesFromApi() async {
    final response = await _apiService.get(ApiConfig.categories);
    List<dynamic> list = [];
    if (response.data is Map && response.data['data'] != null) {
      final raw = response.data['data'];
      if (raw is List) {
        list = raw;
      }
    } else if (response.data is List) {
      list = response.data;
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }
}
