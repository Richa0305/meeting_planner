// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingsModelAdapter extends TypeAdapter<BookingsModel> {
  @override
  final typeId = 2;

  @override
  BookingsModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingsModel(
      bookingTime: fields[0] as String,
      dateTime: fields[1] as DateTime,
      meetingTitle: fields[2] as String,
      meetingDescription: fields[3] as String,
      duration: fields[4] as int,
      meetingRoom: fields[5] as MeetingRoomModel,
      reminder: fields[6] as int,
      priority: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BookingsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.bookingTime)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.meetingTitle)
      ..writeByte(3)
      ..write(obj.meetingDescription)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.meetingRoom)
      ..writeByte(6)
      ..write(obj.reminder)
      ..writeByte(7)
      ..write(obj.priority);
  }
}
