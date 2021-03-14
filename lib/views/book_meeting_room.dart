import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meeting_planner/controller/booking_controller.dart';
import 'package:meeting_planner/models/bookings_model.dart';
import 'package:meeting_planner/models/meeting_room_model.dart';
import 'package:meeting_planner/utilities/common_functions.dart';
import 'package:meeting_planner/utilities/constants.dart';
import 'package:provider/provider.dart';

class BookMeetingRoom extends StatefulWidget {
  final String title;
  final BookingsModel editBookingModel;
  const BookMeetingRoom({this.title, this.editBookingModel});
  @override
  _BookMeetingRoomState createState() => _BookMeetingRoomState();
}

class _BookMeetingRoomState extends State<BookMeetingRoom> {
  final titleTextFieldController = TextEditingController();
  final descriptionTextFieldController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List duration;
  List reminder;
  List priority;
  int selectedDuration;
  int selectedReminder;
  BookingPriority selectedPriority;
  Box<MeetingRoomModel> meetingRoomBox;
  MeetingRoomModel selectedRoom;
  BookingController _bookingController;
  List meetingRoomList = <MeetingRoomModel>[];

  @override
  void initState() {
    // TODO: implement initState
    meetingRoomBox = Hive.box<MeetingRoomModel>(AppConstants.meetingRoom);
    meetingRoomList = meetingRoomBox.values.toList();
    duration = [30, 60, 90, 120, 180];
    reminder = [30, 60, 1440];
    priority = [
      BookingPriority.high,
      BookingPriority.medium,
      BookingPriority.low
    ];
    setSelectedState();
    //selectedRoom = MeetingRoomModel();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bookingController = Provider.of<BookingController>(context);
    super.didChangeDependencies();
  }

  /// Set selected values for edit and intial values for new booking
  void setSelectedState() {
    if (widget.editBookingModel != null) {
      setState(() {
        selectedDuration = widget.editBookingModel.duration;
        selectedReminder = widget.editBookingModel.reminder;
        titleTextFieldController.text = widget.editBookingModel.meetingTitle;
        selectedPriority = widget.editBookingModel.priority != null
            ? BookingPriority.values[widget.editBookingModel.priority]
            : BookingPriority.low;
        selectedRoom = widget.editBookingModel.meetingRoom;
        selectedDate = widget.editBookingModel.dateTime;
        selectedTime = TimeOfDay(
            hour: widget.editBookingModel.dateTime.hour,
            minute: widget.editBookingModel.dateTime.minute);
      });
    } else {
      setState(() {
        selectedPriority = BookingPriority.low;
        selectedDuration = 30;
        selectedReminder = 30;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final formattedTimeOfDay = localizations.formatTimeOfDay(selectedTime);
    final formattedDate = localizations.formatFullDate(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          selectDateView(formattedDate),
          selectTimeView(formattedTimeOfDay),
          CommonFunctions.instance
              .commonTextFieidView("Meeting Title", titleTextFieldController),
          CommonFunctions.instance.commonTextFieidView(
              "Meeting Description", descriptionTextFieldController),
          selectDurationView(),
          selectMeetingRoomView(),
          selectReminderView(),
          selectPriorityView(),
          Spacer(),
          bookMeetingRoomButtonView(context),
        ],
      ),
    );
  }

  @override
  void dispose() {
    titleTextFieldController.dispose();
    descriptionTextFieldController.dispose();
    super.dispose();
  }

  /// show Book Meeting Room button for new booking and Cancel, Save Changes Button for booking edit
  Widget bookMeetingRoomButtonView(BuildContext context) {
    if (widget.editBookingModel != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) => new RaisedButton(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                textColor: Colors.white,
                color: Colors.blue[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {
                  DateTime selectedDateTime = new DateTime(
                      widget.editBookingModel.dateTime.year,
                      widget.editBookingModel.dateTime.month,
                      widget.editBookingModel.dateTime.day,
                      widget.editBookingModel.dateTime.hour,
                      widget.editBookingModel.dateTime.minute);
                  addUpdateBookingsInHive(selectedDateTime, context);
                },
                child: new Text(
                  "Save Changes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            new RaisedButton(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              textColor: Colors.white,
              color: Colors.blue[700],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                _bookingController.del(widget.editBookingModel.bookingTime);
                Navigator.pop(context);
              },
              child: new Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Builder(
          builder: (context) => new RaisedButton(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            textColor: Colors.white,
            color: Colors.blue[700],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: () {
              addUpdateBookingsInHive(selectedDate, context);
            },
            child: new Text(
              "Book Meeting Room",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      );
    }
  }

  /// Add or update booking in Hive
  addUpdateBookingsInHive(DateTime selectedDateTime, BuildContext context) {
    if (selectedRoom != null &&
        titleTextFieldController.text != null &&
        titleTextFieldController.text != "") {
      String bookingTime = DateTime.now().toString();
      BookingsModel bookingsModel = BookingsModel(
          bookingTime: bookingTime,
          dateTime: selectedDateTime,
          meetingTitle: titleTextFieldController.text,
          meetingDescription: descriptionTextFieldController.text,
          duration: selectedDuration,
          meetingRoom: selectedRoom,
          reminder: selectedReminder,
          priority: selectedPriority != null ? selectedPriority.index : 0);
      if (widget.editBookingModel != null) {
        _bookingController.add(
            bookingsModel, widget.editBookingModel.bookingTime);
      } else {
        _bookingController.add(bookingsModel, bookingTime);
      }

      Navigator.pop(context);
    } else {
      CommonFunctions.instance.showToast(context, "Please fill details");
    }
  }

  /// Show date view to change date
  Widget selectDateView(String formattedDate) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: Container(
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.blue[700]),
          child: Center(
            child: Text(
              formattedDate,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  /// Show time view to change time
  Widget selectTimeView(String formattedTimeOfDay) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: GestureDetector(
        onTap: () => _selectTime(context),
        child: Container(
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.blue[700]),
          child: Center(
            child: Text(
              formattedTimeOfDay,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  /// Show duration view to select meeting duration
  Widget selectDurationView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Duration',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          new DropdownButton(
            hint: Text('Select  duration'),
            value: selectedDuration,
            onChanged: (newValue) {
              setState(() {
                selectedDuration = newValue;
              });
            },
            items: duration.map((duration) {
              return DropdownMenuItem(
                child: new Text(
                    CommonFunctions.instance.durationToString(duration)),
                value: duration,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Show meeting room view to select meeting room
  Widget selectMeetingRoomView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Meeting Room',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          new DropdownButton(
            hint: Text('Select Meeting Room'),
            value: selectedRoom,
            onChanged: (newValue) {
              setState(() {
                selectedRoom = newValue as MeetingRoomModel;
              });
            },
            items: meetingRoomList.map((room) {
              return DropdownMenuItem(
                child: new Text(room.meetingRoomTitle),
                value: room,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Show priority  view to select priority
  Widget selectPriorityView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Priority',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          new DropdownButton(
            hint: Text('Select Priority'),
            value: selectedPriority,
            onChanged: (newValue) {
              setState(() {
                selectedPriority = newValue;
              });
            },
            items: priority.map((priority) {
              return DropdownMenuItem(
                child: new Text(priority.toString().split(".").last),
                value: priority,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Show Reminder view to select reminder duration
  Widget selectReminderView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Reminder',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          new DropdownButton(
            hint: Text('Select  Reminder'),
            value: selectedReminder,
            onChanged: (newValue) {
              setState(() {
                selectedReminder = newValue;
              });
            },
            items: reminder.map((reminder) {
              return DropdownMenuItem(
                child: new Text(
                    CommonFunctions.instance.durationToString(reminder)),
                value: reminder,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Show date picker view to select date
  _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2023),
    );
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });
  }

  /// Show time picker view to select time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
      });
  }
}
