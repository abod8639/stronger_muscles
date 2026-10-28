/// Data Transfer Object (DTO) for Checkout Items.
///
/// Strictly decoupled from Domain Entities.
class CheckoutItemModel {
  const CheckoutItemModel({
    required this.productId,
    required this.quantity,
    this.productName = '',
    this.unitPrice = 0.0,
    this.selectedFlavor,
    this.selectedSize,
    this.imageUrl,
  });

  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final String? selectedFlavor;
  final String? selectedSize;
  final String? imageUrl;

  factory CheckoutItemModel.fromJson(Map<String, dynamic> json) {
    return CheckoutItemModel(
      productId: (json['product_id'] ?? json['id'] ?? '').toString(),
      quantity: (json['quantity'] is num)
          ? (json['quantity'] as num).toInt()
          : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      productName: (json['product_name'] ?? json['name'] ?? '').toString(),
      unitPrice: (json['unit_price'] is num)
          ? (json['unit_price'] as num).toDouble()
          : double.tryParse(json['unit_price']?.toString() ?? '0.0') ?? 0.0,
      selectedFlavor: json['selected_flavor']?.toString(),
      selectedSize: json['selected_size']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      if (productName.isNotEmpty) 'product_name': productName,
      if (unitPrice > 0) 'unit_price': unitPrice,
      if (selectedFlavor != null) 'selected_flavor': selectedFlavor,
      if (selectedSize != null) 'selected_size': selectedSize,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}
