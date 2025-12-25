// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressModelAdapter extends TypeAdapter<AddressModel> {
  @override
  final int typeId = 4;

  @override
  AddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressModel(
      id: fields[0] as String,
      label: fields[1] as String,
      fullName: fields[2] as String,
      phoneNumber: fields[3] as String,
      street: fields[4] as String,
      city: fields[5] as String,
      state: fields[6] as String,
      postalCode: fields[7] as String,
      country: fields[8] as String,
      isDefault: fields[9] as bool,
      latitude: fields[10] as double?,
      longitude: fields[11] as double?, userId: '',
    );
  }

  @override
  void write(BinaryWriter writer, AddressModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.street)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.postalCode)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.isDefault)
      ..writeByte(10)
      ..write(obj.latitude)
      ..writeByte(11)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
