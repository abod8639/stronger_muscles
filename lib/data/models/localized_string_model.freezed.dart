// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'localized_string_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LocalizedString _$LocalizedStringFromJson(Map<String, dynamic> json) {
  return _LocalizedString.fromJson(json);
}

/// @nodoc
mixin _$LocalizedString {
  @HiveField(0)
  @JsonKey(name: 'ar')
  String? get ar => throw _privateConstructorUsedError;
  @HiveField(1)
  @JsonKey(name: 'en')
  String? get en => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocalizedStringCopyWith<LocalizedString> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalizedStringCopyWith<$Res> {
  factory $LocalizedStringCopyWith(
    LocalizedString value,
    $Res Function(LocalizedString) then,
  ) = _$LocalizedStringCopyWithImpl<$Res, LocalizedString>;
  @useResult
  $Res call({
    @HiveField(0) @JsonKey(name: 'ar') String? ar,
    @HiveField(1) @JsonKey(name: 'en') String? en,
  });
}

/// @nodoc
class _$LocalizedStringCopyWithImpl<$Res, $Val extends LocalizedString>
    implements $LocalizedStringCopyWith<$Res> {
  _$LocalizedStringCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ar = freezed, Object? en = freezed}) {
    return _then(
      _value.copyWith(
            ar: freezed == ar
                ? _value.ar
                : ar // ignore: cast_nullable_to_non_nullable
                      as String?,
            en: freezed == en
                ? _value.en
                : en // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocalizedStringImplCopyWith<$Res>
    implements $LocalizedStringCopyWith<$Res> {
  factory _$$LocalizedStringImplCopyWith(
    _$LocalizedStringImpl value,
    $Res Function(_$LocalizedStringImpl) then,
  ) = __$$LocalizedStringImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) @JsonKey(name: 'ar') String? ar,
    @HiveField(1) @JsonKey(name: 'en') String? en,
  });
}

/// @nodoc
class __$$LocalizedStringImplCopyWithImpl<$Res>
    extends _$LocalizedStringCopyWithImpl<$Res, _$LocalizedStringImpl>
    implements _$$LocalizedStringImplCopyWith<$Res> {
  __$$LocalizedStringImplCopyWithImpl(
    _$LocalizedStringImpl _value,
    $Res Function(_$LocalizedStringImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ar = freezed, Object? en = freezed}) {
    return _then(
      _$LocalizedStringImpl(
        ar: freezed == ar
            ? _value.ar
            : ar // ignore: cast_nullable_to_non_nullable
                  as String?,
        en: freezed == en
            ? _value.en
            : en // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocalizedStringImpl extends _LocalizedString {
  const _$LocalizedStringImpl({
    @HiveField(0) @JsonKey(name: 'ar') this.ar,
    @HiveField(1) @JsonKey(name: 'en') this.en,
  }) : super._();

  factory _$LocalizedStringImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalizedStringImplFromJson(json);

  @override
  @HiveField(0)
  @JsonKey(name: 'ar')
  final String? ar;
  @override
  @HiveField(1)
  @JsonKey(name: 'en')
  final String? en;

  @override
  String toString() {
    return 'LocalizedString(ar: $ar, en: $en)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalizedStringImpl &&
            (identical(other.ar, ar) || other.ar == ar) &&
            (identical(other.en, en) || other.en == en));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ar, en);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalizedStringImplCopyWith<_$LocalizedStringImpl> get copyWith =>
      __$$LocalizedStringImplCopyWithImpl<_$LocalizedStringImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalizedStringImplToJson(this);
  }
}

abstract class _LocalizedString extends LocalizedString {
  const factory _LocalizedString({
    @HiveField(0) @JsonKey(name: 'ar') final String? ar,
    @HiveField(1) @JsonKey(name: 'en') final String? en,
  }) = _$LocalizedStringImpl;
  const _LocalizedString._() : super._();

  factory _LocalizedString.fromJson(Map<String, dynamic> json) =
      _$LocalizedStringImpl.fromJson;

  @override
  @HiveField(0)
  @JsonKey(name: 'ar')
  String? get ar;
  @override
  @HiveField(1)
  @JsonKey(name: 'en')
  String? get en;
  @override
  @JsonKey(ignore: true)
  _$$LocalizedStringImplCopyWith<_$LocalizedStringImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
