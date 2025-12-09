import 'package:stronger_muscles/data/models/ReviewModel.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final List<String> imageUrl;
  final String description;
  final List<ReviewModel> reviews;
  



  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.reviews,
    });
}
