// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReviewModelAdapter extends TypeAdapter<ReviewModel> {
  @override
  final int typeId = 8;

  @override
  ReviewModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      userId: fields[2] as String,
      userName: fields[3] as String,
      userPhotoUrl: fields[4] as String?,
      comment: fields[5] as String,
      rating: fields[6] as double,
      isVerifiedPurchase: fields[7] as bool,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.userPhotoUrl)
      ..writeByte(5)
      ..write(obj.comment)
      ..writeByte(6)
      ..write(obj.rating)
      ..writeByte(7)
      ..write(obj.isVerifiedPurchase)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
