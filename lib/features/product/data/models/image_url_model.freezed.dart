// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_url_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ImageUrl _$ImageUrlFromJson(Map<String, dynamic> json) {
  return _ImageUrl.fromJson(json);
}

/// @nodoc
mixin _$ImageUrl {
  @HiveField(0)
  @JsonKey(name: 'thumbnail')
  String get thumbnail => throw _privateConstructorUsedError;
  @HiveField(1)
  @JsonKey(name: 'medium')
  String get medium => throw _privateConstructorUsedError;
  @HiveField(2)
  @JsonKey(name: 'original')
  String get original => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImageUrlCopyWith<ImageUrl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageUrlCopyWith<$Res> {
  factory $ImageUrlCopyWith(ImageUrl value, $Res Function(ImageUrl) then) =
      _$ImageUrlCopyWithImpl<$Res, ImageUrl>;
  @useResult
  $Res call({
    @HiveField(0) @JsonKey(name: 'thumbnail') String thumbnail,
    @HiveField(1) @JsonKey(name: 'medium') String medium,
    @HiveField(2) @JsonKey(name: 'original') String original,
  });
}

/// @nodoc
class _$ImageUrlCopyWithImpl<$Res, $Val extends ImageUrl>
    implements $ImageUrlCopyWith<$Res> {
  _$ImageUrlCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = null,
    Object? medium = null,
    Object? original = null,
  }) {
    return _then(
      _value.copyWith(
            thumbnail: null == thumbnail
                ? _value.thumbnail
                : thumbnail // ignore: cast_nullable_to_non_nullable
                      as String,
            medium: null == medium
                ? _value.medium
                : medium // ignore: cast_nullable_to_non_nullable
                      as String,
            original: null == original
                ? _value.original
                : original // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImageUrlImplCopyWith<$Res>
    implements $ImageUrlCopyWith<$Res> {
  factory _$$ImageUrlImplCopyWith(
    _$ImageUrlImpl value,
    $Res Function(_$ImageUrlImpl) then,
  ) = __$$ImageUrlImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) @JsonKey(name: 'thumbnail') String thumbnail,
    @HiveField(1) @JsonKey(name: 'medium') String medium,
    @HiveField(2) @JsonKey(name: 'original') String original,
  });
}

/// @nodoc
class __$$ImageUrlImplCopyWithImpl<$Res>
    extends _$ImageUrlCopyWithImpl<$Res, _$ImageUrlImpl>
    implements _$$ImageUrlImplCopyWith<$Res> {
  __$$ImageUrlImplCopyWithImpl(
    _$ImageUrlImpl _value,
    $Res Function(_$ImageUrlImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = null,
    Object? medium = null,
    Object? original = null,
  }) {
    return _then(
      _$ImageUrlImpl(
        thumbnail: null == thumbnail
            ? _value.thumbnail
            : thumbnail // ignore: cast_nullable_to_non_nullable
                  as String,
        medium: null == medium
            ? _value.medium
            : medium // ignore: cast_nullable_to_non_nullable
                  as String,
        original: null == original
            ? _value.original
            : original // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageUrlImpl extends _ImageUrl {
  const _$ImageUrlImpl({
    @HiveField(0) @JsonKey(name: 'thumbnail') required this.thumbnail,
    @HiveField(1) @JsonKey(name: 'medium') required this.medium,
    @HiveField(2) @JsonKey(name: 'original') required this.original,
  }) : super._();

  factory _$ImageUrlImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageUrlImplFromJson(json);

  @override
  @HiveField(0)
  @JsonKey(name: 'thumbnail')
  final String thumbnail;
  @override
  @HiveField(1)
  @JsonKey(name: 'medium')
  final String medium;
  @override
  @HiveField(2)
  @JsonKey(name: 'original')
  final String original;

  @override
  String toString() {
    return 'ImageUrl(thumbnail: $thumbnail, medium: $medium, original: $original)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageUrlImpl &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.medium, medium) || other.medium == medium) &&
            (identical(other.original, original) ||
                other.original == original));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, thumbnail, medium, original);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageUrlImplCopyWith<_$ImageUrlImpl> get copyWith =>
      __$$ImageUrlImplCopyWithImpl<_$ImageUrlImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageUrlImplToJson(this);
  }
}

abstract class _ImageUrl extends ImageUrl {
  const factory _ImageUrl({
    @HiveField(0) @JsonKey(name: 'thumbnail') required final String thumbnail,
    @HiveField(1) @JsonKey(name: 'medium') required final String medium,
    @HiveField(2) @JsonKey(name: 'original') required final String original,
  }) = _$ImageUrlImpl;
  const _ImageUrl._() : super._();

  factory _ImageUrl.fromJson(Map<String, dynamic> json) =
      _$ImageUrlImpl.fromJson;

  @override
  @HiveField(0)
  @JsonKey(name: 'thumbnail')
  String get thumbnail;
  @override
  @HiveField(1)
  @JsonKey(name: 'medium')
  String get medium;
  @override
  @HiveField(2)
  @JsonKey(name: 'original')
  String get original;
  @override
  @JsonKey(ignore: true)
  _$$ImageUrlImplCopyWith<_$ImageUrlImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
