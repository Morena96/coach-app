// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_log_level_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveLogLevelAdapter extends TypeAdapter<HiveLogLevel> {
  @override
  final int typeId = 12;

  @override
  HiveLogLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HiveLogLevel.debug;
      case 1:
        return HiveLogLevel.info;
      case 2:
        return HiveLogLevel.warning;
      case 3:
        return HiveLogLevel.error;
      default:
        return HiveLogLevel.debug;
    }
  }

  @override
  void write(BinaryWriter writer, HiveLogLevel obj) {
    switch (obj) {
      case HiveLogLevel.debug:
        writer.writeByte(0);
        break;
      case HiveLogLevel.info:
        writer.writeByte(1);
        break;
      case HiveLogLevel.warning:
        writer.writeByte(2);
        break;
      case HiveLogLevel.error:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLogLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
