// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_log_entry_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveLogEntryAdapter extends TypeAdapter<HiveLogEntry> {
  @override
  final int typeId = 11;

  @override
  HiveLogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLogEntry(
      level: fields[0] as HiveLogLevel,
      message: fields[1] as String,
      timestamp: fields[2] as DateTime,
      error: fields[3] as String?,
      stackTrace: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveLogEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.error)
      ..writeByte(4)
      ..write(obj.stackTrace);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
