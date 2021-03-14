import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meeting_planner/controller/booking_controller.dart';
import 'package:meeting_planner/repositories/app_repo.dart';
import 'package:meeting_planner/utilities/constants.dart';
import 'package:meeting_planner/views/meeting_planner_home.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:meeting_planner/models/meeting_room_model.dart';
import 'package:meeting_planner/models/bookings_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(MeetingRoomModelAdapter());
  Hive.registerAdapter(BookingsModelAdapter());
  await Hive.openBox<MeetingRoomModel>(AppConstants.meetingRoom);
  await Hive.openBox<BookingsModel>(AppConstants.booking);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          BookingController(Hive.box<BookingsModel>(AppConstants.booking)),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: RootApp(),
      ),
    );
  }
}

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  void initState() {
    // TODO: implement initState
    AppRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MeetingPlannerHomePage(title: 'Meeting Planner');
  }
}
