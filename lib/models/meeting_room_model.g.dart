// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_room_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingRoomModelAdapter extends TypeAdapter<MeetingRoomModel> {
  @override
  final typeId = 1;

  @override
  MeetingRoomModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeetingRoomModel(
      meetingRoomTitle: fields[0] as String,
      meetingRoomId: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MeetingRoomModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.meetingRoomTitle)
      ..writeByte(1)
      ..write(obj.meetingRoomId);
  }
}
