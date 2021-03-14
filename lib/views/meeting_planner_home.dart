import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meeting_planner/controller/booking_controller.dart';
import 'package:meeting_planner/models/bookings_model.dart';
import 'package:meeting_planner/views/book_meeting_room.dart';
import 'package:meeting_planner/views/settings_view.dart';
import 'package:provider/provider.dart';

class MeetingPlannerHomePage extends StatefulWidget {
  MeetingPlannerHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MeetingPlannerHomePageState createState() => _MeetingPlannerHomePageState();
}

class _MeetingPlannerHomePageState extends State<MeetingPlannerHomePage> {
  DateTime selectedDate = DateTime.now();
  Box<BookingsModel> bookingBox;
  BookingController _bookingController;
  List<BookingsModel> bookingList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bookingController = Provider.of<BookingController>(context);
    bookingList = _bookingController.getAll(selectedDate);
    bookingList.sort((a, b) => a.priority.compareTo(b.priority));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final formattedDate = localizations.formatFullDate(selectedDate);
    AppBar appBar = AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsView(
                        title: "Settings",
                      )),
            );
          },
        )
      ],
    );
    return Scaffold(
        appBar: appBar,
        body: Center(
          child: Column(
            children: <Widget>[
              dateView(formattedDate),
              addNewButtonView(),
              bookingsListView(appBar.preferredSize.height),
            ],
          ),
        ));
  }

  /// show list of bookings for selected date
  Widget bookingsListView(double appBarHeight) {
    if (bookingList.isEmpty) {
      return Center(child: Text("No Bookings available"));
    } else {
      return Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - (appBarHeight + 180),
        child: ListView.builder(
          itemCount: bookingList.length,
          itemBuilder: (context, index) {
            String formattedTime =
                DateFormat.jm().format(bookingList[index].dateTime);
            return Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text(
                      bookingList[index].meetingTitle,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Meeting Room : ' +
                          bookingList[index].meetingRoom.meetingRoomTitle +
                          ' | Time : ' +
                          formattedTime,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    trailing: Icon(Icons.edit),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookMeetingRoom(
                                  title: "Edit Booking",
                                  editBookingModel: bookingList[index],
                                )),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  /// show date view to change date
  Widget dateView(String formattedDate) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.blue[700]),
        child: Center(
          child: Text(
            formattedDate,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// show date picker view to change date
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2023),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        bookingList = _bookingController.getAll(selectedDate);
        bookingList.sort((a, b) => a.priority.compareTo(b.priority));
      });
  }

  /// show Add New Meeting button
  Widget addNewButtonView() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookMeetingRoom(
                      title: "New Meeting Booking",
                      editBookingModel: null,
                    )),
          );
        },
        child: Text(
          'Add New Meeting',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: Colors.blue[700],
      ),
    );
  }
}
