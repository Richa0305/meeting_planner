import 'package:hive/hive.dart';

part 'meeting_room_model.g.dart';

@HiveType(typeId: 1)
class MeetingRoomModel {
  @HiveField(0)
  final String meetingRoomTitle;
  @HiveField(1)
  final int meetingRoomId;

  MeetingRoomModel({this.meetingRoomTitle, this.meetingRoomId});

  bool operator ==(dynamic other) {
    return other is MeetingRoomModel &&
        this.meetingRoomTitle == other.meetingRoomTitle &&
        this.meetingRoomId == other.meetingRoomId;
  }

  @override
  int get hashCode {
    int hashCode = 1;
    hashCode = (23 * hashCode) + this.meetingRoomTitle.hashCode;
    hashCode = (23 * hashCode) + this.meetingRoomId.hashCode;
    return hashCode;
  }
}
