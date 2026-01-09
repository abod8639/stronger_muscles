import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
class CartItemModel with _$CartItemModel {
  @HiveType(typeId: 0, adapterName: 'CartItemModelAdapter')
  const factory CartItemModel({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'user_id') required String userId,
    @HiveField(2) required ProductModel product,
    @HiveField(3) @Default(1) int quantity,
    @HiveField(4) @JsonKey(name: 'added_at') DateTime? addedAt,
    @HiveField(5) @JsonKey(name: 'selected_flavor') String? selectedFlavor,
    @HiveField(6) @JsonKey(name: 'selected_size') String? selectedSize,
  }) = _CartItemModel;

  const CartItemModel._();

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  double get subtotal => product.effectivePrice * quantity;
  String? get primaryImageUrl =>
      product.imageUrls.isNotEmpty ? product.imageUrls.first : null;
}
