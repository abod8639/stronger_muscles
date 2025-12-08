import 'package:stronger_muscles/data/models/ReviewModel.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final List<String> imageUrl;
  final String description;
  final double? strars;
  final int? reviewCount;
  final List<ReviewModel> reviews;
  



  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.strars,
    this.reviewCount,
    this.reviews = const [],});
}
