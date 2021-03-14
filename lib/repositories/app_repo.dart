import 'package:meeting_planner/models/meeting_room_model.dart';
import 'package:hive/hive.dart';
import 'package:meeting_planner/utilities/constants.dart';

class AppRepository {
  // static final AppRepository _singleton = AppRepository();
  // static AppRepository get instance => _singleton;

  AppRepository() {
    addMeetingRooms();
  }

  /// Add meeting rooms
  addMeetingRooms() async {
    Box<MeetingRoomModel> meetingRoomBox =
        Hive.box<MeetingRoomModel>(AppConstants.meetingRoom);
    if (meetingRoomBox.get(0) == null) {
      meetingRoomBox
          .add(MeetingRoomModel(meetingRoomId: 1, meetingRoomTitle: "M1"));
      meetingRoomBox
          .add(MeetingRoomModel(meetingRoomId: 2, meetingRoomTitle: "M2"));
      meetingRoomBox
          .add(MeetingRoomModel(meetingRoomId: 3, meetingRoomTitle: "M3"));
      meetingRoomBox
          .add(MeetingRoomModel(meetingRoomId: 4, meetingRoomTitle: "M4"));
    }
  }
}
