// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SystemConfigModelAdapter extends TypeAdapter<SystemConfigModel> {
  @override
  final int typeId = 0;

  @override
  SystemConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SystemConfigModel()
      ..blockList = (fields[0] as List).cast<String>()
      ..isInit = fields[1] as bool;
  }

  @override
  void write(BinaryWriter writer, SystemConfigModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.blockList)
      ..writeByte(1)
      ..write(obj.isInit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
