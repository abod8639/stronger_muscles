import 'package:stronger_muscles/features/product/product_feature.dart';

/// Extension mappers for Product Details feature to strictly decouple Models (DTOs) from Entities.
extension ProductDetailsModelMapper on ProductModel {
  ProductEntity toDomainEntity() => toEntity();
}

extension ProductDetailsEntityMapper on ProductEntity {
  ProductModel toDataModel() => ProductModel.fromEntity(this);
}

extension ProductDetailsReviewModelMapper on ReviewModel {
  ReviewEntity toDomainEntity() => toEntity();
}

extension ProductDetailsReviewEntityMapper on ReviewEntity {
  ReviewModel toDataModel() => ReviewModel.fromEntity(this);
}
