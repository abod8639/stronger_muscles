class ProductModel {
  final String id;
  final String name;
  final double price;
  final List<String> imageUrl;
  final String description;
  final double? strars;
  final int? reviewCount;


  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.strars,
    this.reviewCount,
  });
}
