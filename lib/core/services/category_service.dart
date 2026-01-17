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

      print('DEBUG: Response status: ${response.statusCode}');
      
      final decodedData = jsonDecode(response.body);
      List<CategoryModel> categories = [];

      if (decodedData is Map) {
        if (decodedData['data'] is List) {
           final list = decodedData['data'] as List;
           categories = list.map((json) => CategoryModel.fromJson(json)).toList();
        } else if (decodedData['status'] == 'success' && decodedData['data'] != null) {
           // Handle another common wrap if needed
        }
      } else if (decodedData is List) {
         categories = decodedData.map((json) => CategoryModel.fromJson(json)).toList();
      }

      if (categories.isNotEmpty) {
        await _cacheCategories(categories);
      }
      return categories;
    } on Failure catch (e) {
      print("DEBUG: Failure in getCategories: ${e.message}");
      // Note: We could fallback to cache here if network fails
      rethrow;
    } catch (e) {
      print("DEBUG: Error in getCategories: $e");
      throw Failure(message: "حدث خطأ غير متوقع عند جلب الأقسام", type: FailureType.unknown, originalError: e);
    }
  }
}
