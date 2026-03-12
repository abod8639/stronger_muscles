import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';

class CategoryRemoteDataSource extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<CategoryModel>> fetchCategoriesFromApi() async {
    final response = await _apiService.get(ApiConfig.categories);
    List<dynamic> list = (response.data is Map) ? response.data['data'] : response.data;
    return list.map((json) => CategoryModel.fromJson(json)).toList();
  }
}