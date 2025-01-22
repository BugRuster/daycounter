// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countdown_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountdownEventAdapter extends TypeAdapter<CountdownEvent> {
  @override
  final int typeId = 0;

  @override
  CountdownEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountdownEvent(
      title: fields[0] as String,
      targetDate: fields[1] as DateTime,
      description: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CountdownEvent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.targetDate)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountdownEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
