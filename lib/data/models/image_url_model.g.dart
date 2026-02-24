// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_url_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageUrlAdapter extends TypeAdapter<ImageUrl> {
  @override
  final int typeId = 12;

  @override
  ImageUrl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageUrl(
      thumbnail: fields[0] as String,
      medium: fields[1] as String,
      original: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ImageUrl obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.thumbnail)
      ..writeByte(1)
      ..write(obj.medium)
      ..writeByte(2)
      ..write(obj.original);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageUrlAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImageUrlImpl _$$ImageUrlImplFromJson(Map<String, dynamic> json) =>
    _$ImageUrlImpl(
      thumbnail: json['thumbnail'] as String,
      medium: json['medium'] as String,
      original: json['original'] as String,
    );

Map<String, dynamic> _$$ImageUrlImplToJson(_$ImageUrlImpl instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'medium': instance.medium,
      'original': instance.original,
    };
