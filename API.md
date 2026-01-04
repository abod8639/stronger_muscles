class ApiConfig {
// الرابط الأساسي (Base URL)
static const String baseUrl = 'http://localhost:8080/api/v1';

// ملاحظة: للهاتف الحقيقي استخدم IP الجهاز، وللمحاكي (Android Emulator) استخدم 10.0.2.2
// static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

// روابط المنتجات
static const String products = '/products';
static String productDetail(String id) => '/products/$id';

// روابط التصنيفات
static const String categories = '/categories';

// روابط المستخدم والحساب
static const String userProfile = '/user'; // يتطلب Token
static const String login = '/login';
static const String register = '/register';
}

class ProductModel {
final String id;
final String name;
final double price;
final double? discountPrice;
final List<String> imageUrls;
final String description;
final String categoryId;
final int stockQuantity;
final double averageRating;
final int reviewCount;
final String? brand;
final String? servingSize;
final int? servingsPerContainer;
final bool isActive;

ProductModel({
required this.id,
required this.name,
required this.price,
this.discountPrice,
required this.imageUrls,
required this.description,
required this.categoryId,
this.stockQuantity = 0,
this.averageRating = 0.0,
this.reviewCount = 0,
this.brand,
this.servingSize,
this.servingsPerContainer,
this.isActive = true,
});

factory ProductModel.fromJson(Map<String, dynamic> json) {
return ProductModel(
id: json['id'],
name: json['name'],
price: double.parse(json['price'].toString()),
discountPrice: json['discount_price'] != null ? double.parse(json['discount_price'].toString()) : null,
imageUrls: List<String>.from(json['image_urls'] ?? []),
description: json['description'],
categoryId: json['category_id'],
stockQuantity: json['stock_quantity'] ?? 0,
averageRating: double.parse(json['average_rating'].toString()),
reviewCount: json['review_count'] ?? 0,
brand: json['brand'],
servingSize: json['serving_size'],
servingsPerContainer: json['servings_per_container'],
isActive: json['is_active'] == 1 || json['is_active'] == true,
);
}
}

class CategoryModel {
final String id;
final String name;
final String? description;
final String? imageUrl;
final int sortOrder;
final bool isActive;

CategoryModel({
required this.id,
required this.name,
this.description,
this.imageUrl,
this.sortOrder = 0,
this.isActive = true,
});

factory CategoryModel.fromJson(Map<String, dynamic> json) {
return CategoryModel(
id: json['id'],
name: json['name'],
description: json['description'],
imageUrl: json['image_url'],
sortOrder: json['sort_order'] ?? 0,
isActive: json['is_active'] == 1 || json['is_active'] == true,
);
}
}

class UserModel {
final int id;
final String name;
final String email;
final String? photoUrl;
final String? phoneNumber;
final String preferredLanguage;
final bool notificationsEnabled;

UserModel({
required this.id,
required this.name,
required this.email,
this.photoUrl,
this.phoneNumber,
this.preferredLanguage = 'ar',
this.notificationsEnabled = true,
});

factory UserModel.fromJson(Map<String, dynamic> json) {
return UserModel(
id: json['id'],
name: json['name'],
email: json['email'],
photoUrl: json['photo_url'],
phoneNumber: json['phone_number'],
preferredLanguage: json['preferred_language'] ?? 'ar',
notificationsEnabled: json['notifications_enabled'] == 1 || json['notifications_enabled'] == true,
);
}
}

enum OrderStatus { pending, processing, shipped, delivered, cancelled }
enum PaymentStatus { pending, paid, failed, refunded }

class OrderModel {
final String id;
final String userId;
final DateTime orderDate;
final OrderStatus status;
final PaymentStatus paymentStatus;
final String paymentMethod;
final String addressId;
final Map<String, dynamic>? shippingAddressSnapshot;
final double subtotal;
final double shippingCost;
final double discount;
final double totalAmount;
final String? trackingNumber;
final String? notes;
final List<OrderItemModel>? items;

OrderModel({
required this.id,
required this.userId,
required this.orderDate,
this.status = OrderStatus.pending,
this.paymentStatus = PaymentStatus.pending,
this.paymentMethod = 'card',
required this.addressId,
this.shippingAddressSnapshot,
required this.subtotal,
this.shippingCost = 0.0,
this.discount = 0.0,
required this.totalAmount,
this.trackingNumber,
this.notes,
this.items,
});

factory OrderModel.fromJson(Map<String, dynamic> json) {
return OrderModel(
id: json['id'],
userId: json['user_id'],
orderDate: DateTime.parse(json['order_date']),
status: OrderStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => OrderStatus.pending),
paymentStatus: PaymentStatus.values.firstWhere((e) => e.name == json['payment_status'], orElse: () => PaymentStatus.pending),
paymentMethod: json['payment_method'],
addressId: json['address_id'],
shippingAddressSnapshot: json['shipping_address_snapshot'],
subtotal: double.parse(json['subtotal'].toString()),
shippingCost: double.parse(json['shipping_cost'].toString()),
discount: double.parse(json['discount'].toString()),
totalAmount: double.parse(json['total_amount'].toString()),
trackingNumber: json['tracking_number'],
notes: json['notes'],
items: json['order_items'] != null
? (json['order_items'] as List).map((i) => OrderItemModel.fromJson(i)).toList()
: null,
);
}
}

class OrderItemModel {
final String id;
final String orderId;
final String productId;
final String productName;
final double unitPrice;
final int quantity;
final double subtotal;
final String? imageUrl;

OrderItemModel({
required this.id,
required this.orderId,
required this.productId,
required this.productName,
required this.unitPrice,
required this.quantity,
required this.subtotal,
this.imageUrl,
});

factory OrderItemModel.fromJson(Map<String, dynamic> json) {
return OrderItemModel(
id: json['id'],
orderId: json['order_id'],
productId: json['product_id'],
productName: json['product_name'],
unitPrice: double.parse(json['unit_price'].toString()),
quantity: json['quantity'],
subtotal: double.parse(json['subtotal'].toString()),
imageUrl: json['image_url'],
);
}
}

class CartItemModel {
final String id;
final String userId;
final String productId;
final String productName;
final double price;
final List<String> imageUrls;
final int quantity;
final DateTime addedAt;

CartItemModel({
required this.id,
required this.userId,
required this.productId,
required this.productName,
required this.price,
required this.imageUrls,
required this.quantity,
required this.addedAt,
});

factory CartItemModel.fromJson(Map<String, dynamic> json) {
return CartItemModel(
id: json['id'],
userId: json['user_id'],
productId: json['product_id'],
productName: json['product_name'],
price: double.parse(json['price'].toString()),
imageUrls: List<String>.from(json['image_urls'] ?? []),
quantity: json['quantity'],
addedAt: DateTime.parse(json['added_at']),
);
}
}
