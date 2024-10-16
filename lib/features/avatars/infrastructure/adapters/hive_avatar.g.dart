// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_avatar.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveAvatarAdapter extends TypeAdapter<HiveAvatar> {
  @override
  final int typeId = 10;

  @override
  HiveAvatar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAvatar(
      id: fields[0] as String,
      localPath: fields[1] as String,
      lastUpdated: fields[2] as DateTime,
      syncStatus: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveAvatar obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.localPath)
      ..writeByte(2)
      ..write(obj.lastUpdated)
      ..writeByte(3)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAvatarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
