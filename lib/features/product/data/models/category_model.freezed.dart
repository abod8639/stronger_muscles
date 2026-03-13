// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return _CategoryModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  LocalizedString? get name => throw _privateConstructorUsedError;
  @HiveField(2)
  LocalizedString? get description => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get imageUrl => throw _privateConstructorUsedError;
  @HiveField(4)
  int get sortOrder => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get icon => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get parentId => throw _privateConstructorUsedError;
  @HiveField(9)
  List<CategoryModel> get children => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryModelCopyWith<CategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryModelCopyWith<$Res> {
  factory $CategoryModelCopyWith(
          CategoryModel value, $Res Function(CategoryModel) then) =
      _$CategoryModelCopyWithImpl<$Res, CategoryModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) LocalizedString? name,
      @HiveField(2) LocalizedString? description,
      @HiveField(3) String? imageUrl,
      @HiveField(4) int sortOrder,
      @HiveField(5) bool isActive,
      @HiveField(6) DateTime? createdAt,
      @HiveField(7) String? icon,
      @HiveField(8) String? parentId,
      @HiveField(9) List<CategoryModel> children});

  $LocalizedStringCopyWith<$Res>? get name;
  $LocalizedStringCopyWith<$Res>? get description;
}

/// @nodoc
class _$CategoryModelCopyWithImpl<$Res, $Val extends CategoryModel>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? icon = freezed,
    Object? parentId = freezed,
    Object? children = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as LocalizedString?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as LocalizedString?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LocalizedStringCopyWith<$Res>? get name {
    if (_value.name == null) {
      return null;
    }

    return $LocalizedStringCopyWith<$Res>(_value.name!, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LocalizedStringCopyWith<$Res>? get description {
    if (_value.description == null) {
      return null;
    }

    return $LocalizedStringCopyWith<$Res>(_value.description!, (value) {
      return _then(_value.copyWith(description: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryModelImplCopyWith<$Res>
    implements $CategoryModelCopyWith<$Res> {
  factory _$$CategoryModelImplCopyWith(
          _$CategoryModelImpl value, $Res Function(_$CategoryModelImpl) then) =
      __$$CategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) LocalizedString? name,
      @HiveField(2) LocalizedString? description,
      @HiveField(3) String? imageUrl,
      @HiveField(4) int sortOrder,
      @HiveField(5) bool isActive,
      @HiveField(6) DateTime? createdAt,
      @HiveField(7) String? icon,
      @HiveField(8) String? parentId,
      @HiveField(9) List<CategoryModel> children});

  @override
  $LocalizedStringCopyWith<$Res>? get name;
  @override
  $LocalizedStringCopyWith<$Res>? get description;
}

/// @nodoc
class __$$CategoryModelImplCopyWithImpl<$Res>
    extends _$CategoryModelCopyWithImpl<$Res, _$CategoryModelImpl>
    implements _$$CategoryModelImplCopyWith<$Res> {
  __$$CategoryModelImplCopyWithImpl(
      _$CategoryModelImpl _value, $Res Function(_$CategoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? icon = freezed,
    Object? parentId = freezed,
    Object? children = null,
  }) {
    return _then(_$CategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as LocalizedString?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as LocalizedString?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryModelImpl extends _CategoryModel {
  const _$CategoryModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) this.name,
      @HiveField(2) this.description,
      @HiveField(3) this.imageUrl,
      @HiveField(4) this.sortOrder = 0,
      @HiveField(5) this.isActive = true,
      @HiveField(6) this.createdAt,
      @HiveField(7) this.icon,
      @HiveField(8) this.parentId,
      @HiveField(9) final List<CategoryModel> children = const []})
      : _children = children,
        super._();

  factory _$CategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final LocalizedString? name;
  @override
  @HiveField(2)
  final LocalizedString? description;
  @override
  @HiveField(3)
  final String? imageUrl;
  @override
  @JsonKey()
  @HiveField(4)
  final int sortOrder;
  @override
  @JsonKey()
  @HiveField(5)
  final bool isActive;
  @override
  @HiveField(6)
  final DateTime? createdAt;
  @override
  @HiveField(7)
  final String? icon;
  @override
  @HiveField(8)
  final String? parentId;
  final List<CategoryModel> _children;
  @override
  @JsonKey()
  @HiveField(9)
  List<CategoryModel> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, description: $description, imageUrl: $imageUrl, sortOrder: $sortOrder, isActive: $isActive, createdAt: $createdAt, icon: $icon, parentId: $parentId, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      imageUrl,
      sortOrder,
      isActive,
      createdAt,
      icon,
      parentId,
      const DeepCollectionEquality().hash(_children));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      __$$CategoryModelImplCopyWithImpl<_$CategoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryModel extends CategoryModel {
  const factory _CategoryModel(
      {@HiveField(0) required final String id,
      @HiveField(1) final LocalizedString? name,
      @HiveField(2) final LocalizedString? description,
      @HiveField(3) final String? imageUrl,
      @HiveField(4) final int sortOrder,
      @HiveField(5) final bool isActive,
      @HiveField(6) final DateTime? createdAt,
      @HiveField(7) final String? icon,
      @HiveField(8) final String? parentId,
      @HiveField(9) final List<CategoryModel> children}) = _$CategoryModelImpl;
  const _CategoryModel._() : super._();

  factory _CategoryModel.fromJson(Map<String, dynamic> json) =
      _$CategoryModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  LocalizedString? get name;
  @override
  @HiveField(2)
  LocalizedString? get description;
  @override
  @HiveField(3)
  String? get imageUrl;
  @override
  @HiveField(4)
  int get sortOrder;
  @override
  @HiveField(5)
  bool get isActive;
  @override
  @HiveField(6)
  DateTime? get createdAt;
  @override
  @HiveField(7)
  String? get icon;
  @override
  @HiveField(8)
  String? get parentId;
  @override
  @HiveField(9)
  List<CategoryModel> get children;
  @override
  @JsonKey(ignore: true)
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
