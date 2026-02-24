// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localized_string_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalizedStringAdapter extends TypeAdapter<LocalizedString> {
  @override
  final int typeId = 11;

  @override
  LocalizedString read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalizedString(
      ar: fields[0] as String,
      en: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalizedString obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ar)
      ..writeByte(1)
      ..write(obj.en);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalizedStringAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocalizedStringImpl _$$LocalizedStringImplFromJson(
        Map<String, dynamic> json) =>
    _$LocalizedStringImpl(
      ar: json['ar'] as String,
      en: json['en'] as String,
    );

Map<String, dynamic> _$$LocalizedStringImplToJson(
        _$LocalizedStringImpl instance) =>
    <String, dynamic>{
      'ar': instance.ar,
      'en': instance.en,
    };
