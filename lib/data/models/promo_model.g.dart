// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromoModelImplAdapter extends TypeAdapter<_$PromoModelImpl> {
  @override
  final int typeId = 10;

  @override
  _$PromoModelImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$PromoModelImpl(
      id: fields[0] as int,
      title: fields[1] as String?,
      subtitle: fields[2] as String?,
      imageUrl: fields[3] as String,
      buttonText: fields[4] as String,
      hexBackgroundColor: fields[5] as String,
      targetType: fields[6] as String,
      targetId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, _$PromoModelImpl obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.buttonText)
      ..writeByte(5)
      ..write(obj.hexBackgroundColor)
      ..writeByte(6)
      ..write(obj.targetType)
      ..writeByte(7)
      ..write(obj.targetId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromoModelImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromoModelImpl _$$PromoModelImplFromJson(Map<String, dynamic> json) =>
    _$PromoModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['image_url'] as String,
      buttonText: json['button_text'] as String? ?? 'عرض الآن',
      hexBackgroundColor: json['background_color'] as String? ?? '#FFFFFF',
      targetType: json['target_type'] as String? ?? 'none',
      targetId: json['target_id'] as String?,
    );

Map<String, dynamic> _$$PromoModelImplToJson(_$PromoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'image_url': instance.imageUrl,
      'button_text': instance.buttonText,
      'background_color': instance.hexBackgroundColor,
      'target_type': instance.targetType,
      'target_id': instance.targetId,
    };
