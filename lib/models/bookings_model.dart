import 'package:hive/hive.dart';
import 'package:meeting_planner/models/meeting_room_model.dart';

part 'bookings_model.g.dart';

@HiveType(typeId: 2)
class BookingsModel {
  @HiveField(0)
  final String bookingTime;
  @HiveField(1)
  final DateTime dateTime;
  @HiveField(2)
  final String meetingTitle;
  @HiveField(3)
  final String meetingDescription;
  @HiveField(4)
  final int duration;
  @HiveField(5)
  final MeetingRoomModel meetingRoom;
  @HiveField(6)
  final int reminder;
  @HiveField(7)
  final int priority;

  BookingsModel(
      {this.bookingTime,
      this.dateTime,
      this.meetingTitle,
      this.meetingDescription,
      this.duration,
      this.meetingRoom,
      this.reminder,
      this.priority});
}
