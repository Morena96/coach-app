// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_athlete.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveAthleteAdapter extends TypeAdapter<HiveAthlete> {
  @override
  final int typeId = 1;

  @override
  HiveAthlete read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAthlete(
      id: fields[0] as String,
      name: fields[1] as String,
      avatarId: fields[2] as String?,
      sportIds: (fields[3] as List?)?.cast<String>(),
      archived: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveAthlete obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatarId)
      ..writeByte(3)
      ..write(obj.sportIds)
      ..writeByte(4)
      ..write(obj.archived);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAthleteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
