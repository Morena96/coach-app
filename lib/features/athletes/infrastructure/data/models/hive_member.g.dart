// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_member.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMemberAdapter extends TypeAdapter<HiveMember> {
  @override
  final int typeId = 3;

  @override
  HiveMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMember(
      id: fields[0] as String,
      athleteId: fields[1] as String,
      groupId: fields[2] as String,
      role: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMember obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.athleteId)
      ..writeByte(2)
      ..write(obj.groupId)
      ..writeByte(3)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
