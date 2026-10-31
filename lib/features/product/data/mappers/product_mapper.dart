import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import 'package:stronger_muscles/features/product/data/models/image_url_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_category_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_size_model.dart';
import 'package:stronger_muscles/features/product/data/models/review_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/image_url_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_category_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_size_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/review_entity.dart';

/// Extension mappers to convert between Product data models (DTOs) and domain entities.
extension ProductModelMapper on ProductModel {
  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name?.toEntity(),
        description: description?.toEntity(),
        brand: brand,
        category: category?.toEntity(),
        imageUrls: imageUrls.map((i) => i.toEntity()).toList(),
        hasVariants: hasVariants,
        price: price,
        discountPrice: discountPrice,
        stockQuantity: stockQuantity,
        averageRating: averageRating,
        reviewCount: reviewCount,
        servingSize: servingSize,
        servingsPerContainer: servingsPerContainer,
        nutritionFacts: nutritionFacts,
        flavors: flavors,
        productSizes: productSizes.map((s) => s.toEntity()).toList(),
        size: size,
        tags: tags,
        weight: weight,
        isActive: isActive,
        isBackgroundWhite: isBackgroundWhite,
        featured: featured,
        newArrival: newArrival,
        bestSeller: bestSeller,
        sku: sku,
        totalSales: totalSales,
        createdAt: createdAt,
        updatedAt: updatedAt,
        ingredients: ingredients,
        manufacturer: manufacturer,
        countryOfOrigin: countryOfOrigin,
        usageInstructions: usageInstructions,
        warnings: warnings,
      );
}

extension ProductEntityMapper on ProductEntity {
  ProductModel toModel() => ProductModel.fromEntity(this);
}

extension CategoryModelMapper on CategoryModel {
  CategoryEntity toEntity() => CategoryEntity(
        id: id,
        name: name?.toEntity(),
        description: description?.toEntity(),
        imageUrl: imageUrl,
        sortOrder: sortOrder,
        isActive: isActive,
        createdAt: createdAt,
        icon: icon,
        parentId: parentId,
        children: children.map((c) => c.toEntity()).toList(),
      );
}

extension CategoryEntityMapper on CategoryEntity {
  CategoryModel toModel() => CategoryModel.fromEntity(this);
}

extension ImageUrlModelMapper on ImageUrl {
  ImageUrlEntity toEntity() => ImageUrlEntity(
        thumbnail: thumbnail,
        medium: medium,
        original: original,
      );
}

extension ImageUrlEntityMapper on ImageUrlEntity {
  ImageUrl toModel() => ImageUrl.fromEntity(this);
}

extension ProductCategoryModelMapper on ProductCategory {
  ProductCategoryEntity toEntity() => ProductCategoryEntity(
        id: id,
        name: name?.toEntity(),
      );
}

extension ProductCategoryEntityMapper on ProductCategoryEntity {
  ProductCategory toModel() => ProductCategory.fromEntity(this);
}

extension ProductSizeModelMapper on ProductSize {
  ProductSizeEntity toEntity() => ProductSizeEntity(
        size: size,
        price: price,
        discountPrice: discountPrice,
        servings: servings,
        weight: weight,
        stockQuantity: stockQuantity,
      );
}

extension ProductSizeEntityMapper on ProductSizeEntity {
  ProductSize toModel() => ProductSize.fromEntity(this);
}

extension ReviewModelMapper on ReviewModel {
  ReviewEntity toEntity() => ReviewEntity(
        id: id,
        productId: productId,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        comment: comment,
        rating: rating,
        isVerifiedPurchase: isVerifiedPurchase,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension ReviewEntityMapper on ReviewEntity {
  ReviewModel toModel() => ReviewModel.fromEntity(this);
}
