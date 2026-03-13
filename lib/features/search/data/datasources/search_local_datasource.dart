import 'dart:math' as math;
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

class SearchLocalDataSource {
  /// فلترة القائمة بناءً على السعر
  List<ProductModel> filterByPrice(List<ProductModel> products, double min, double max) {
    return products.where((p) => p.price >= min && p.price <= max).toList();
  }

  /// حساب أدنى وأقصى سعر في القائمة الحالية
  Map<String, double> calculatePriceBounds(List<ProductModel> products) {
    if (products.isEmpty) {
      return {'min': 100, 'max': 10000};
    }
    double min = products.first.price;
    double max = products.first.price;
    for (var p in products) {
      min = math.min(min, p.price);
      max = math.max(max, p.price);
    }
    return {'min': min, 'max': max};
  }
}