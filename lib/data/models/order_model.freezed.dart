// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @HiveField(2)
  @JsonKey(name: 'order_date')
  DateTime get orderDate => throw _privateConstructorUsedError;
  @HiveField(3)
  String get status => throw _privateConstructorUsedError;
  @HiveField(4)
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  @HiveField(5)
  @JsonKey(name: 'payment_method')
  String get paymentMethod => throw _privateConstructorUsedError;
  @HiveField(6)
  @JsonKey(name: 'address_id')
  String get addressId => throw _privateConstructorUsedError;
  @HiveField(8)
  double get subtotal => throw _privateConstructorUsedError;
  @HiveField(9)
  @JsonKey(name: 'shippingCost')
  double get shippingCost => throw _privateConstructorUsedError;
  @HiveField(10)
  double get discount => throw _privateConstructorUsedError;
  @HiveField(11)
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @HiveField(12)
  @JsonKey(name: 'tracking_number')
  String? get trackingNumber => throw _privateConstructorUsedError;
  @HiveField(13)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(14)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(15)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(16)
  @JsonKey(name: 'order_items')
  List<OrderItemModel>? get items => throw _privateConstructorUsedError;
  @HiveField(17)
  @JsonKey(name: 'shipping_address')
  AddressModel? get shippingAddress => throw _privateConstructorUsedError;
  @HiveField(18)
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @HiveField(19)
  @JsonKey(name: 'user_name')
  String? get userName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) @JsonKey(name: 'user_id') String userId,
      @HiveField(2) @JsonKey(name: 'order_date') DateTime orderDate,
      @HiveField(3) String status,
      @HiveField(4) @JsonKey(name: 'payment_status') String paymentStatus,
      @HiveField(5) @JsonKey(name: 'payment_method') String paymentMethod,
      @HiveField(6) @JsonKey(name: 'address_id') String addressId,
      @HiveField(8) double subtotal,
      @HiveField(9) @JsonKey(name: 'shippingCost') double shippingCost,
      @HiveField(10) double discount,
      @HiveField(11) @JsonKey(name: 'total_amount') double totalAmount,
      @HiveField(12) @JsonKey(name: 'tracking_number') String? trackingNumber,
      @HiveField(13) String? notes,
      @HiveField(14) DateTime? createdAt,
      @HiveField(15) DateTime? updatedAt,
      @HiveField(16) @JsonKey(name: 'order_items') List<OrderItemModel>? items,
      @HiveField(17)
      @JsonKey(name: 'shipping_address')
      AddressModel? shippingAddress,
      @HiveField(18) @JsonKey(name: 'phone_number') String? phoneNumber,
      @HiveField(19) @JsonKey(name: 'user_name') String? userName});

  $AddressModelCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? orderDate = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = null,
    Object? addressId = null,
    Object? subtotal = null,
    Object? shippingCost = null,
    Object? discount = null,
    Object? totalAmount = null,
    Object? trackingNumber = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? items = freezed,
    Object? shippingAddress = freezed,
    Object? phoneNumber = freezed,
    Object? userName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orderDate: null == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      addressId: null == addressId
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      shippingCost: null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>?,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get shippingAddress {
    if (_value.shippingAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.shippingAddress!, (value) {
      return _then(_value.copyWith(shippingAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) @JsonKey(name: 'user_id') String userId,
      @HiveField(2) @JsonKey(name: 'order_date') DateTime orderDate,
      @HiveField(3) String status,
      @HiveField(4) @JsonKey(name: 'payment_status') String paymentStatus,
      @HiveField(5) @JsonKey(name: 'payment_method') String paymentMethod,
      @HiveField(6) @JsonKey(name: 'address_id') String addressId,
      @HiveField(8) double subtotal,
      @HiveField(9) @JsonKey(name: 'shippingCost') double shippingCost,
      @HiveField(10) double discount,
      @HiveField(11) @JsonKey(name: 'total_amount') double totalAmount,
      @HiveField(12) @JsonKey(name: 'tracking_number') String? trackingNumber,
      @HiveField(13) String? notes,
      @HiveField(14) DateTime? createdAt,
      @HiveField(15) DateTime? updatedAt,
      @HiveField(16) @JsonKey(name: 'order_items') List<OrderItemModel>? items,
      @HiveField(17)
      @JsonKey(name: 'shipping_address')
      AddressModel? shippingAddress,
      @HiveField(18) @JsonKey(name: 'phone_number') String? phoneNumber,
      @HiveField(19) @JsonKey(name: 'user_name') String? userName});

  @override
  $AddressModelCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? orderDate = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = null,
    Object? addressId = null,
    Object? subtotal = null,
    Object? shippingCost = null,
    Object? discount = null,
    Object? totalAmount = null,
    Object? trackingNumber = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? items = freezed,
    Object? shippingAddress = freezed,
    Object? phoneNumber = freezed,
    Object? userName = freezed,
  }) {
    return _then(_$OrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orderDate: null == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      addressId: null == addressId
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      shippingCost: null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>?,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl extends _OrderModel {
  const _$OrderModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) @JsonKey(name: 'user_id') required this.userId,
      @HiveField(2) @JsonKey(name: 'order_date') required this.orderDate,
      @HiveField(3) this.status = 'pending',
      @HiveField(4)
      @JsonKey(name: 'payment_status')
      this.paymentStatus = 'pending',
      @HiveField(5)
      @JsonKey(name: 'payment_method')
      this.paymentMethod = 'card',
      @HiveField(6) @JsonKey(name: 'address_id') required this.addressId,
      @HiveField(8) required this.subtotal,
      @HiveField(9) @JsonKey(name: 'shippingCost') this.shippingCost = 0,
      @HiveField(10) this.discount = 0,
      @HiveField(11) @JsonKey(name: 'total_amount') required this.totalAmount,
      @HiveField(12) @JsonKey(name: 'tracking_number') this.trackingNumber,
      @HiveField(13) this.notes,
      @HiveField(14) this.createdAt,
      @HiveField(15) this.updatedAt,
      @HiveField(16)
      @JsonKey(name: 'order_items')
      final List<OrderItemModel>? items,
      @HiveField(17) @JsonKey(name: 'shipping_address') this.shippingAddress,
      @HiveField(18) @JsonKey(name: 'phone_number') this.phoneNumber,
      @HiveField(19) @JsonKey(name: 'user_name') this.userName})
      : _items = items,
        super._();

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @HiveField(2)
  @JsonKey(name: 'order_date')
  final DateTime orderDate;
  @override
  @JsonKey()
  @HiveField(3)
  final String status;
  @override
  @HiveField(4)
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @override
  @HiveField(5)
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  @HiveField(6)
  @JsonKey(name: 'address_id')
  final String addressId;
  @override
  @HiveField(8)
  final double subtotal;
  @override
  @HiveField(9)
  @JsonKey(name: 'shippingCost')
  final double shippingCost;
  @override
  @JsonKey()
  @HiveField(10)
  final double discount;
  @override
  @HiveField(11)
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @HiveField(12)
  @JsonKey(name: 'tracking_number')
  final String? trackingNumber;
  @override
  @HiveField(13)
  final String? notes;
  @override
  @HiveField(14)
  final DateTime? createdAt;
  @override
  @HiveField(15)
  final DateTime? updatedAt;
  final List<OrderItemModel>? _items;
  @override
  @HiveField(16)
  @JsonKey(name: 'order_items')
  List<OrderItemModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @HiveField(17)
  @JsonKey(name: 'shipping_address')
  final AddressModel? shippingAddress;
  @override
  @HiveField(18)
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @override
  @HiveField(19)
  @JsonKey(name: 'user_name')
  final String? userName;

  @override
  String toString() {
    return 'OrderModel(id: $id, userId: $userId, orderDate: $orderDate, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, addressId: $addressId, subtotal: $subtotal, shippingCost: $shippingCost, discount: $discount, totalAmount: $totalAmount, trackingNumber: $trackingNumber, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, shippingAddress: $shippingAddress, phoneNumber: $phoneNumber, userName: $userName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.userName, userName) ||
                other.userName == userName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        orderDate,
        status,
        paymentStatus,
        paymentMethod,
        addressId,
        subtotal,
        shippingCost,
        discount,
        totalAmount,
        trackingNumber,
        notes,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_items),
        shippingAddress,
        phoneNumber,
        userName
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel extends OrderModel {
  const factory _OrderModel(
      {@HiveField(0) required final String id,
      @HiveField(1) @JsonKey(name: 'user_id') required final String userId,
      @HiveField(2)
      @JsonKey(name: 'order_date')
      required final DateTime orderDate,
      @HiveField(3) final String status,
      @HiveField(4) @JsonKey(name: 'payment_status') final String paymentStatus,
      @HiveField(5) @JsonKey(name: 'payment_method') final String paymentMethod,
      @HiveField(6)
      @JsonKey(name: 'address_id')
      required final String addressId,
      @HiveField(8) required final double subtotal,
      @HiveField(9) @JsonKey(name: 'shippingCost') final double shippingCost,
      @HiveField(10) final double discount,
      @HiveField(11)
      @JsonKey(name: 'total_amount')
      required final double totalAmount,
      @HiveField(12)
      @JsonKey(name: 'tracking_number')
      final String? trackingNumber,
      @HiveField(13) final String? notes,
      @HiveField(14) final DateTime? createdAt,
      @HiveField(15) final DateTime? updatedAt,
      @HiveField(16)
      @JsonKey(name: 'order_items')
      final List<OrderItemModel>? items,
      @HiveField(17)
      @JsonKey(name: 'shipping_address')
      final AddressModel? shippingAddress,
      @HiveField(18) @JsonKey(name: 'phone_number') final String? phoneNumber,
      @HiveField(19)
      @JsonKey(name: 'user_name')
      final String? userName}) = _$OrderModelImpl;
  const _OrderModel._() : super._();

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @HiveField(2)
  @JsonKey(name: 'order_date')
  DateTime get orderDate;
  @override
  @HiveField(3)
  String get status;
  @override
  @HiveField(4)
  @JsonKey(name: 'payment_status')
  String get paymentStatus;
  @override
  @HiveField(5)
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @override
  @HiveField(6)
  @JsonKey(name: 'address_id')
  String get addressId;
  @override
  @HiveField(8)
  double get subtotal;
  @override
  @HiveField(9)
  @JsonKey(name: 'shippingCost')
  double get shippingCost;
  @override
  @HiveField(10)
  double get discount;
  @override
  @HiveField(11)
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @HiveField(12)
  @JsonKey(name: 'tracking_number')
  String? get trackingNumber;
  @override
  @HiveField(13)
  String? get notes;
  @override
  @HiveField(14)
  DateTime? get createdAt;
  @override
  @HiveField(15)
  DateTime? get updatedAt;
  @override
  @HiveField(16)
  @JsonKey(name: 'order_items')
  List<OrderItemModel>? get items;
  @override
  @HiveField(17)
  @JsonKey(name: 'shipping_address')
  AddressModel? get shippingAddress;
  @override
  @HiveField(18)
  @JsonKey(name: 'phone_number')
  String? get phoneNumber;
  @override
  @HiveField(19)
  @JsonKey(name: 'user_name')
  String? get userName;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return _OrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrderItemModel {
  @HiveField(0)
  String get id =>
      throw _privateConstructorUsedError; // can be empty for new items
  @HiveField(1)
  @JsonKey(name: 'order_id')
  String get orderId => throw _privateConstructorUsedError;
  @HiveField(2)
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @HiveField(3)
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @HiveField(4)
  @JsonKey(name: 'unit_price')
  double get unitPrice => throw _privateConstructorUsedError;
  @HiveField(5)
  int get quantity => throw _privateConstructorUsedError;
  @HiveField(6)
  double get subtotal => throw _privateConstructorUsedError;
  @HiveField(7)
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(9)
  @JsonKey(name: 'selectedFlavor')
  String? get selectedFlavor =>
      throw _privateConstructorUsedError; // تم التعديل
  @HiveField(10)
  @JsonKey(name: 'selectedSize')
  String? get selectedSize => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
          OrderItemModel value, $Res Function(OrderItemModel) then) =
      _$OrderItemModelCopyWithImpl<$Res, OrderItemModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) @JsonKey(name: 'order_id') String orderId,
      @HiveField(2) @JsonKey(name: 'product_id') String productId,
      @HiveField(3) @JsonKey(name: 'product_name') String productName,
      @HiveField(4) @JsonKey(name: 'unit_price') double unitPrice,
      @HiveField(5) int quantity,
      @HiveField(6) double subtotal,
      @HiveField(7) @JsonKey(name: 'image_url') String? imageUrl,
      @HiveField(8) DateTime? createdAt,
      @HiveField(9) @JsonKey(name: 'selectedFlavor') String? selectedFlavor,
      @HiveField(10) @JsonKey(name: 'selectedSize') String? selectedSize});
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res, $Val extends OrderItemModel>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = null,
    Object? productName = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? subtotal = null,
    Object? imageUrl = freezed,
    Object? createdAt = freezed,
    Object? selectedFlavor = freezed,
    Object? selectedSize = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedFlavor: freezed == selectedFlavor
          ? _value.selectedFlavor
          : selectedFlavor // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedSize: freezed == selectedSize
          ? _value.selectedSize
          : selectedSize // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemModelImplCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$$OrderItemModelImplCopyWith(_$OrderItemModelImpl value,
          $Res Function(_$OrderItemModelImpl) then) =
      __$$OrderItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) @JsonKey(name: 'order_id') String orderId,
      @HiveField(2) @JsonKey(name: 'product_id') String productId,
      @HiveField(3) @JsonKey(name: 'product_name') String productName,
      @HiveField(4) @JsonKey(name: 'unit_price') double unitPrice,
      @HiveField(5) int quantity,
      @HiveField(6) double subtotal,
      @HiveField(7) @JsonKey(name: 'image_url') String? imageUrl,
      @HiveField(8) DateTime? createdAt,
      @HiveField(9) @JsonKey(name: 'selectedFlavor') String? selectedFlavor,
      @HiveField(10) @JsonKey(name: 'selectedSize') String? selectedSize});
}

/// @nodoc
class __$$OrderItemModelImplCopyWithImpl<$Res>
    extends _$OrderItemModelCopyWithImpl<$Res, _$OrderItemModelImpl>
    implements _$$OrderItemModelImplCopyWith<$Res> {
  __$$OrderItemModelImplCopyWithImpl(
      _$OrderItemModelImpl _value, $Res Function(_$OrderItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = null,
    Object? productName = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? subtotal = null,
    Object? imageUrl = freezed,
    Object? createdAt = freezed,
    Object? selectedFlavor = freezed,
    Object? selectedSize = freezed,
  }) {
    return _then(_$OrderItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedFlavor: freezed == selectedFlavor
          ? _value.selectedFlavor
          : selectedFlavor // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedSize: freezed == selectedSize
          ? _value.selectedSize
          : selectedSize // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemModelImpl implements _OrderItemModel {
  const _$OrderItemModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) @JsonKey(name: 'order_id') required this.orderId,
      @HiveField(2) @JsonKey(name: 'product_id') required this.productId,
      @HiveField(3) @JsonKey(name: 'product_name') required this.productName,
      @HiveField(4) @JsonKey(name: 'unit_price') required this.unitPrice,
      @HiveField(5) required this.quantity,
      @HiveField(6) required this.subtotal,
      @HiveField(7) @JsonKey(name: 'image_url') this.imageUrl,
      @HiveField(8) this.createdAt,
      @HiveField(9) @JsonKey(name: 'selectedFlavor') this.selectedFlavor,
      @HiveField(10) @JsonKey(name: 'selectedSize') this.selectedSize});

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
// can be empty for new items
  @override
  @HiveField(1)
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  @HiveField(2)
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @HiveField(3)
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @HiveField(4)
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @override
  @HiveField(5)
  final int quantity;
  @override
  @HiveField(6)
  final double subtotal;
  @override
  @HiveField(7)
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @HiveField(8)
  final DateTime? createdAt;
  @override
  @HiveField(9)
  @JsonKey(name: 'selectedFlavor')
  final String? selectedFlavor;
// تم التعديل
  @override
  @HiveField(10)
  @JsonKey(name: 'selectedSize')
  final String? selectedSize;

  @override
  String toString() {
    return 'OrderItemModel(id: $id, orderId: $orderId, productId: $productId, productName: $productName, unitPrice: $unitPrice, quantity: $quantity, subtotal: $subtotal, imageUrl: $imageUrl, createdAt: $createdAt, selectedFlavor: $selectedFlavor, selectedSize: $selectedSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.selectedFlavor, selectedFlavor) ||
                other.selectedFlavor == selectedFlavor) &&
            (identical(other.selectedSize, selectedSize) ||
                other.selectedSize == selectedSize));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderId,
      productId,
      productName,
      unitPrice,
      quantity,
      subtotal,
      imageUrl,
      createdAt,
      selectedFlavor,
      selectedSize);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      __$$OrderItemModelImplCopyWithImpl<_$OrderItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemModelImplToJson(
      this,
    );
  }
}

abstract class _OrderItemModel implements OrderItemModel {
  const factory _OrderItemModel(
      {@HiveField(0) required final String id,
      @HiveField(1) @JsonKey(name: 'order_id') required final String orderId,
      @HiveField(2)
      @JsonKey(name: 'product_id')
      required final String productId,
      @HiveField(3)
      @JsonKey(name: 'product_name')
      required final String productName,
      @HiveField(4)
      @JsonKey(name: 'unit_price')
      required final double unitPrice,
      @HiveField(5) required final int quantity,
      @HiveField(6) required final double subtotal,
      @HiveField(7) @JsonKey(name: 'image_url') final String? imageUrl,
      @HiveField(8) final DateTime? createdAt,
      @HiveField(9)
      @JsonKey(name: 'selectedFlavor')
      final String? selectedFlavor,
      @HiveField(10)
      @JsonKey(name: 'selectedSize')
      final String? selectedSize}) = _$OrderItemModelImpl;

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override // can be empty for new items
  @HiveField(1)
  @JsonKey(name: 'order_id')
  String get orderId;
  @override
  @HiveField(2)
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @HiveField(3)
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @HiveField(4)
  @JsonKey(name: 'unit_price')
  double get unitPrice;
  @override
  @HiveField(5)
  int get quantity;
  @override
  @HiveField(6)
  double get subtotal;
  @override
  @HiveField(7)
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @HiveField(8)
  DateTime? get createdAt;
  @override
  @HiveField(9)
  @JsonKey(name: 'selectedFlavor')
  String? get selectedFlavor;
  @override // تم التعديل
  @HiveField(10)
  @JsonKey(name: 'selectedSize')
  String? get selectedSize;
  @override
  @JsonKey(ignore: true)
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
