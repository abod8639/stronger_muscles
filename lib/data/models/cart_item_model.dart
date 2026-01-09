import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
class CartItemModel with _$CartItemModel {
  @HiveType(typeId: 0, adapterName: 'CartItemModelAdapter')
  const factory CartItemModel({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'user_id') required String userId,
    @HiveField(2) @JsonKey(name: 'product_id') required String productId,
    @HiveField(3) @JsonKey(name: 'product_name') required String productName,
    @HiveField(4) required double price,
    @HiveField(5) @JsonKey(name: 'image_urls') @Default([]) List<String> imageUrls,
    @HiveField(6) @Default(1) int quantity,
    @HiveField(7) @JsonKey(name: 'added_at') DateTime? addedAt,
    @HiveField(8) @JsonKey(name: 'selected_flavor') String? selectedFlavor,
    @HiveField(9) String? brand,
    @HiveField(10) double? weight,
    @HiveField(11) String? size,
    @HiveField(12) String? sku,
    @HiveField(13) @JsonKey(name: 'category_id') String? categoryId,
    @HiveField(14) @JsonKey(name: 'flavors') @Default([]) List<String>? flavors,

  }) = _CartItemModel;

  const CartItemModel._();

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);

  double get subtotal => price * quantity;
  String? get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;
}
