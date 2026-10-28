import 'package:flutter/foundation.dart';

/// Immutable state for Product Details.
@immutable
class ProductDetailsState {
  final int selectedImageIndex;
  final String selectedFlavor;
  final dynamic selectedSizeObject;
  final bool isInWishlist;
  final double displayPrice;
  final double displayEffectivePrice;
  final bool displayHasDiscount;
  final bool isPriceZero;

  const ProductDetailsState({
    this.selectedImageIndex = 0,
    this.selectedFlavor = '',
    this.selectedSizeObject,
    this.isInWishlist = false,
    this.displayPrice = 0.0,
    this.displayEffectivePrice = 0.0,
    this.displayHasDiscount = false,
    this.isPriceZero = false,
  });

  ProductDetailsState copyWith({
    int? selectedImageIndex,
    String? selectedFlavor,
    dynamic selectedSizeObject,
    bool? isInWishlist,
    double? displayPrice,
    double? displayEffectivePrice,
    bool? displayHasDiscount,
    bool? isPriceZero,
  }) {
    return ProductDetailsState(
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      selectedFlavor: selectedFlavor ?? this.selectedFlavor,
      selectedSizeObject: selectedSizeObject ?? this.selectedSizeObject,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      displayPrice: displayPrice ?? this.displayPrice,
      displayEffectivePrice: displayEffectivePrice ?? this.displayEffectivePrice,
      displayHasDiscount: displayHasDiscount ?? this.displayHasDiscount,
      isPriceZero: isPriceZero ?? this.isPriceZero,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDetailsState &&
          runtimeType == other.runtimeType &&
          selectedImageIndex == other.selectedImageIndex &&
          selectedFlavor == other.selectedFlavor &&
          selectedSizeObject == other.selectedSizeObject &&
          isInWishlist == other.isInWishlist &&
          displayPrice == other.displayPrice &&
          displayEffectivePrice == other.displayEffectivePrice &&
          displayHasDiscount == other.displayHasDiscount &&
          isPriceZero == other.isPriceZero;

  @override
  int get hashCode =>
      selectedImageIndex.hashCode ^
      selectedFlavor.hashCode ^
      selectedSizeObject.hashCode ^
      isInWishlist.hashCode ^
      displayPrice.hashCode ^
      displayEffectivePrice.hashCode ^
      displayHasDiscount.hashCode ^
      isPriceZero.hashCode;
}
