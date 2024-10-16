// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveSettingAdapter extends TypeAdapter<HiveSetting> {
  @override
  final int typeId = 0;

  @override
  HiveSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveSetting(
      settingKey: fields[0] as String,
      settingValue: fields[1] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, HiveSetting obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.settingKey)
      ..writeByte(1)
      ..write(obj.settingValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
