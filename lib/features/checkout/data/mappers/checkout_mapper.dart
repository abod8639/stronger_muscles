import '../../domain/entities/checkout_params.dart';
import '../../domain/entities/checkout_quote.dart';
import '../../domain/entities/checkout_result_entity.dart';
import '../models/checkout_item_model.dart';
import '../models/checkout_params_model.dart';
import '../models/checkout_quote_model.dart';
import '../models/checkout_result_model.dart';

/// Extension mapper to convert [CheckoutItemModel] (DTO) to [CheckoutItemEntity] (Domain).
extension CheckoutItemModelMapper on CheckoutItemModel {
  CheckoutItemEntity toEntity() {
    return CheckoutItemEntity(
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
      imageUrl: imageUrl,
    );
  }
}

/// Extension mapper to convert [CheckoutItemEntity] (Domain) to [CheckoutItemModel] (DTO).
extension CheckoutItemEntityMapper on CheckoutItemEntity {
  CheckoutItemModel toModel() {
    return CheckoutItemModel(
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
      imageUrl: imageUrl,
    );
  }
}

/// Extension mapper to convert [CheckoutParams] (Domain) to [CheckoutParamsModel] (DTO).
extension CheckoutParamsMapper on CheckoutParams {
  CheckoutParamsModel toModel() {
    return CheckoutParamsModel(
      addressId: addressId,
      paymentMethod: paymentMethod,
      notes: notes,
      items: items.map((i) => i.toModel()).toList(),
      customerName: customerName,
    );
  }

  Map<String, dynamic> toPayload() => toModel().toPayload();
}

/// Extension mapper to convert [CheckoutResultModel] (DTO) to [CheckoutResultEntity] (Domain).
extension CheckoutResultModelMapper on CheckoutResultModel {
  CheckoutResultEntity toEntity() {
    return CheckoutResultEntity(
      orderId: orderId,
      status: status,
      message: message,
      paymentUrl: paymentUrl,
      rawData: rawData,
    );
  }
}

/// Extension mapper to convert [CheckoutResultEntity] (Domain) to [CheckoutResultModel] (DTO).
extension CheckoutResultEntityMapper on CheckoutResultEntity {
  CheckoutResultModel toModel() {
    return CheckoutResultModel(
      orderId: orderId,
      status: status,
      message: message,
      paymentUrl: paymentUrl,
      rawData: rawData,
    );
  }
}

/// Extension mapper to convert [CheckoutQuoteModel] (DTO) to [CheckoutQuote] (Domain).
extension CheckoutQuoteModelMapper on CheckoutQuoteModel {
  CheckoutQuote toEntity() {
    return CheckoutQuote(
      subtotal: subtotal,
      shippingCost: shippingCost,
      taxAmount: taxAmount,
      discount: discount,
      totalAmount: totalAmount,
      taxRate: taxRate,
      freeDeliveryThreshold: freeDeliveryThreshold,
      currency: currency,
      isAcceptingOrders: isAcceptingOrders,
    );
  }
}
