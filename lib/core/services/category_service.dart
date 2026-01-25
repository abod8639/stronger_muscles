import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../config/api_config.dart';
import '../../data/models/category_model.dart';
import '../errors/failures.dart';

class CategoryService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  static const String _categoryBoxName = 'categories';

  Future<List<CategoryModel>> getCachedCategories() async {
    try {
      if (!Hive.isBoxOpen(_categoryBoxName)) {
        await Hive.openBox<CategoryModel>(_categoryBoxName);
      }
      final box = Hive.box<CategoryModel>(_categoryBoxName);
      return box.values.toList();
    } catch (e) {
      print('DEBUG: Error reading cached categories: $e');
      return [];
    }
  }

  Future<void> _cacheCategories(List<CategoryModel> categories) async {
    try {
      if (!Hive.isBoxOpen(_categoryBoxName)) {
        await Hive.openBox<CategoryModel>(_categoryBoxName);
      }
      final box = Hive.box<CategoryModel>(_categoryBoxName);
      await box.clear();
      await box.addAll(categories);
      print('DEBUG: Categories cached successfully');
    } catch (e) {
      print('DEBUG: Error caching categories: $e');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiService.get(ApiConfig.categories);

      print('DEBUG: Categories Response status: ${response.statusCode}');

      final dynamic decodedData = jsonDecode(response.body);
      List<CategoryModel> categoriesResult = [];

      if (decodedData is List) {
        categoriesResult = decodedData
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else if (decodedData is Map) {
        final dynamic data = decodedData['data'];
        if (data is List) {
          categoriesResult = data
              .map((json) => CategoryModel.fromJson(json))
              .toList();
        } else if (decodedData['status'] == 'success' && data != null) {
          // Some APIs wrap success responses differently
          if (data is List) {
            categoriesResult = data
                .map((json) => CategoryModel.fromJson(json))
                .toList();
          }
        }
      }

      if (categoriesResult.isNotEmpty) {
        await _cacheCategories(categoriesResult);
      }
      return categoriesResult;
    } on Failure catch (e) {
      print("DEBUG: Failure in getCategories: ${e.message}");
      // Fallback to cache if network fails
      return await getCachedCategories();
    } catch (e) {
      print("DEBUG: Error in getCategories: $e");
      // Fallback to cache if unexpected error
      return await getCachedCategories();
    }
  }
}
