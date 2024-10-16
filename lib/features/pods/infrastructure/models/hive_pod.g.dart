// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_pod.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePodAdapter extends TypeAdapter<HivePod> {
  @override
  final int typeId = 1;

  @override
  HivePod read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePod(
      id: fields[0] as String,
      number: fields[1] as int,
      athleteId: fields[2] as String?,
      rfSlot: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HivePod obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.athleteId)
      ..writeByte(3)
      ..write(obj.rfSlot);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
