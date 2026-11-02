// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PromoModel _$PromoModelFromJson(Map<String, dynamic> json) {
  return _PromoModel.fromJson(json);
}

/// @nodoc
mixin _$PromoModel {
  @HiveField(0)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get title => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get subtitle => throw _privateConstructorUsedError;
  @HiveField(3)
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @HiveField(4)
  @JsonKey(name: 'button_text', defaultValue: 'عرض الآن')
  String get buttonText => throw _privateConstructorUsedError;
  @HiveField(5)
  @JsonKey(name: 'background_color', defaultValue: '#FFFFFF')
  String get hexBackgroundColor => throw _privateConstructorUsedError;
  @HiveField(6)
  @JsonKey(name: 'target_type', defaultValue: 'none')
  String get targetType => throw _privateConstructorUsedError;
  @HiveField(7)
  @JsonKey(name: 'target_id')
  String? get targetId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PromoModelCopyWith<PromoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromoModelCopyWith<$Res> {
  factory $PromoModelCopyWith(
    PromoModel value,
    $Res Function(PromoModel) then,
  ) = _$PromoModelCopyWithImpl<$Res, PromoModel>;
  @useResult
  $Res call({
    @HiveField(0) int id,
    @HiveField(1) String? title,
    @HiveField(2) String? subtitle,
    @HiveField(3) @JsonKey(name: 'image_url') String imageUrl,
    @HiveField(4)
    @JsonKey(name: 'button_text', defaultValue: 'عرض الآن')
    String buttonText,
    @HiveField(5)
    @JsonKey(name: 'background_color', defaultValue: '#FFFFFF')
    String hexBackgroundColor,
    @HiveField(6)
    @JsonKey(name: 'target_type', defaultValue: 'none')
    String targetType,
    @HiveField(7) @JsonKey(name: 'target_id') String? targetId,
  });
}

/// @nodoc
class _$PromoModelCopyWithImpl<$Res, $Val extends PromoModel>
    implements $PromoModelCopyWith<$Res> {
  _$PromoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? subtitle = freezed,
    Object? imageUrl = null,
    Object? buttonText = null,
    Object? hexBackgroundColor = null,
    Object? targetType = null,
    Object? targetId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            subtitle: freezed == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            buttonText: null == buttonText
                ? _value.buttonText
                : buttonText // ignore: cast_nullable_to_non_nullable
                      as String,
            hexBackgroundColor: null == hexBackgroundColor
                ? _value.hexBackgroundColor
                : hexBackgroundColor // ignore: cast_nullable_to_non_nullable
                      as String,
            targetType: null == targetType
                ? _value.targetType
                : targetType // ignore: cast_nullable_to_non_nullable
                      as String,
            targetId: freezed == targetId
                ? _value.targetId
                : targetId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PromoModelImplCopyWith<$Res>
    implements $PromoModelCopyWith<$Res> {
  factory _$$PromoModelImplCopyWith(
    _$PromoModelImpl value,
    $Res Function(_$PromoModelImpl) then,
  ) = __$$PromoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) int id,
    @HiveField(1) String? title,
    @HiveField(2) String? subtitle,
    @HiveField(3) @JsonKey(name: 'image_url') String imageUrl,
    @HiveField(4)
    @JsonKey(name: 'button_text', defaultValue: 'عرض الآن')
    String buttonText,
    @HiveField(5)
    @JsonKey(name: 'background_color', defaultValue: '#FFFFFF')
    String hexBackgroundColor,
    @HiveField(6)
    @JsonKey(name: 'target_type', defaultValue: 'none')
    String targetType,
    @HiveField(7) @JsonKey(name: 'target_id') String? targetId,
  });
}

/// @nodoc
class __$$PromoModelImplCopyWithImpl<$Res>
    extends _$PromoModelCopyWithImpl<$Res, _$PromoModelImpl>
    implements _$$PromoModelImplCopyWith<$Res> {
  __$$PromoModelImplCopyWithImpl(
    _$PromoModelImpl _value,
    $Res Function(_$PromoModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? subtitle = freezed,
    Object? imageUrl = null,
    Object? buttonText = null,
    Object? hexBackgroundColor = null,
    Object? targetType = null,
    Object? targetId = freezed,
  }) {
    return _then(
      _$PromoModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        subtitle: freezed == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        buttonText: null == buttonText
            ? _value.buttonText
            : buttonText // ignore: cast_nullable_to_non_nullable
                  as String,
        hexBackgroundColor: null == hexBackgroundColor
            ? _value.hexBackgroundColor
            : hexBackgroundColor // ignore: cast_nullable_to_non_nullable
                  as String,
        targetType: null == targetType
            ? _value.targetType
            : targetType // ignore: cast_nullable_to_non_nullable
                  as String,
        targetId: freezed == targetId
            ? _value.targetId
            : targetId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 10)
class _$PromoModelImpl extends _PromoModel {
  const _$PromoModelImpl({
    @HiveField(0) required this.id,
    @HiveField(1) this.title,
    @HiveField(2) this.subtitle,
    @HiveField(3) @JsonKey(name: 'image_url') required this.imageUrl,
    @HiveField(4)
    @JsonKey(name: 'button_text', defaultValue: 'عرض الآن')
    required this.buttonText,
    @HiveField(5)
    @JsonKey(name: 'background_color', defaultValue: '#FFFFFF')
    required this.hexBackgroundColor,
    @HiveField(6)
    @JsonKey(name: 'target_type', defaultValue: 'none')
    required this.targetType,
    @HiveField(7) @JsonKey(name: 'target_id') this.targetId,
  }) : super._();

  factory _$PromoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromoModelImplFromJson(json);

  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String? title;
  @override
  @HiveField(2)
  final String? subtitle;
  @override
  @HiveField(3)
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @HiveField(4)
  @JsonKey(name: 'button_text', defaultValue: 'عرض الآن')
  final String buttonText;
  @override
  @HiveField(5)
  @JsonKey(name: 'background_color', defaultValue: '#FFFFFF')
  final String hexBackgroundColor;
  @override
  @HiveField(6)
  @JsonKey(name: 'target_type', defaultValue: 'none')
  final String targetType;
  @override
  @HiveField(7)
  @JsonKey(name: 'target_id')
  final String? targetId;

  @override
  String toString() {
    return 'PromoModel(id: $id, title: $title, subtitle: $subtitle, imageUrl: $imageUrl, buttonText: $buttonText, hexBackgroundColor: $hexBackgroundColor, targetType: $targetType, targetId: $targetId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.buttonText, buttonText) ||
                other.buttonText == buttonText) &&
            (identical(other.hexBackgroundColor, hexBackgroundColor) ||
                other.hexBackgroundColor == hexBackgroundColor) &&
            (identical(other.targetType, targetType) ||
                other.targetType == targetType) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    subtitle,
    imageUrl,
    buttonText,
    hexBackgroundColor,
    targetType,
    targetId,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromoModelImplCopyWith<_$PromoModelImpl> get copyWith =>
      __$$PromoModelImplCopyWithImpl<_$PromoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromoModelImplToJson(this);
  }
}

abstract class _PromoModel extends PromoModel {
  const factory _PromoModel({
    @HiveField(0) required final int id,
    @HiveField(1) final String? title,
    @HiveField(2) final String? subtitle,
    @HiveField(3) @JsonKey(name: 'image_url') required final String imageUrl,
    @HiveField(4)
    @JsonKey(name: 'button_text', defaultValue: 'عرض الآن')
    required final String buttonText,
    @HiveField(5)
    @JsonKey(name: 'background_color', defaultValue: '#FFFFFF')
    required final String hexBackgroundColor,
    @HiveField(6)
    @JsonKey(name: 'target_type', defaultValue: 'none')
    required final String targetType,
    @HiveField(7) @JsonKey(name: 'target_id') final String? targetId,
  }) = _$PromoModelImpl;
  const _PromoModel._() : super._();

  factory _PromoModel.fromJson(Map<String, dynamic> json) =
      _$PromoModelImpl.fromJson;

  @override
  @HiveField(0)
  int get id;
  @override
  @HiveField(1)
  String? get title;
  @override
  @HiveField(2)
  String? get subtitle;
  @override
  @HiveField(3)
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  @HiveField(4)
  @JsonKey(name: 'button_text', defaultValue: 'عرض الآن')
  String get buttonText;
  @override
  @HiveField(5)
  @JsonKey(name: 'background_color', defaultValue: '#FFFFFF')
  String get hexBackgroundColor;
  @override
  @HiveField(6)
  @JsonKey(name: 'target_type', defaultValue: 'none')
  String get targetType;
  @override
  @HiveField(7)
  @JsonKey(name: 'target_id')
  String? get targetId;
  @override
  @JsonKey(ignore: true)
  _$$PromoModelImplCopyWith<_$PromoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
