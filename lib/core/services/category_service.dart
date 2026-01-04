import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../config/api_config.dart';
import '../../data/models/category_model.dart';
import '../errors/failures.dart';

class CategoryService extends GetxService {
  String get _categoryBaseUrl => '${ApiConfig.baseUrl}${ApiConfig.categories}';
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
      print('DEBUG: Fetching categories from $_categoryBaseUrl');
      final response = await http.get(Uri.parse(_categoryBaseUrl));

      print('DEBUG: Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        List<CategoryModel> categories = [];

        if (decodedData is Map && decodedData['status'] == 'success' && decodedData['data'] is List) {
           final list = decodedData['data'] as List;
           categories = list.map((json) => CategoryModel.fromJson(json)).toList();
        } else if (decodedData is List) {
           categories = decodedData.map((json) => CategoryModel.fromJson(json)).toList();
        }

        if (categories.isNotEmpty) {
          await _cacheCategories(categories);
        }
        return categories;
      } else {
         throw Failure(
            message: "خطأ في تحميل الأقسام: ${response.statusCode}",
            type: FailureType.server,
         );
      }
    } catch (e) {
      print("DEBUG: Error in getCategories: $e");
      if (e is Failure) rethrow;

      if (e is http.ClientException || e.toString().contains('SocketException')) {
        throw Failure(
          message: "تعذر الوصول إلى الخادم لجلب الأقسام", 
          type: FailureType.network, 
          originalError: e
        );
      }
      
      throw Failure(message: "حدث خطأ غير متوقع عند جلب الأقسام: $e", type: FailureType.unknown, originalError: e);
    }
  }
}
