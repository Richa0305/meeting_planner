import 'package:flutter/material.dart';
import 'package:meeting_planner/utilities/common_functions.dart';

enum OfficeHourType { fromType, toType }

class SettingsView extends StatefulWidget {
  SettingsView({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  List timezoneList;
  String selectedTimeZone;
  TimeOfDay selectedFromTime;
  TimeOfDay selectedToTime;
  final fromHourTextFieldController = TextEditingController();
  final toHourTextFieldController = TextEditingController();
  bool swBool = true;
  @override
  void initState() {
    // TODO: implement initState
    timezoneList = [
      "India(IST)",
      "Central Amarica (CST)",
      "Eastern Standard (EST)"
    ];
    selectedFromTime = TimeOfDay(hour: 9, minute: 00);
    selectedToTime = TimeOfDay(hour: 17, minute: 00);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final formattedFromTimeOfDay =
        localizations.formatTimeOfDay(selectedFromTime);
    final formattedToTimeOfDay = localizations.formatTimeOfDay(selectedToTime);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Update Office Hours",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  selectTimeView(
                      formattedFromTimeOfDay, OfficeHourType.fromType),
                  Text("To", style: TextStyle(fontWeight: FontWeight.bold)),
                  selectTimeView(formattedToTimeOfDay, OfficeHourType.toType),
                ],
              ),
              selectTimezoneView(),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Notification",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    new Switch(
                        value: swBool,
                        onChanged: (bool sw) {
                          setState(() {
                            swBool = sw;
                          });
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fromHourTextFieldController.dispose();
    super.dispose();
  }

  Widget selectTimeView(String formattedTimeOfDay, OfficeHourType type) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: GestureDetector(
        onTap: () => _selectTime(context, type),
        child: Container(
          padding: EdgeInsets.all(8),
          width: 80,
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

  Future<void> _selectTime(BuildContext context, OfficeHourType type) async {
    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime:
            type == OfficeHourType.fromType ? selectedFromTime : selectedToTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (pickedTime != null &&
        pickedTime !=
            (type == OfficeHourType.fromType
                ? selectedFromTime
                : selectedToTime))
      setState(() {
        if (type == OfficeHourType.fromType) {
          selectedFromTime = pickedTime;
        } else {
          selectedToTime = pickedTime;
        }
      });
  }

  Widget selectTimezoneView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Change Timezone',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          new DropdownButton(
            hint: Text('Change Timezone'),
            value: selectedTimeZone,
            onChanged: (newValue) {
              setState(() {
                selectedTimeZone = newValue;
              });
            },
            items: timezoneList.map((timezone) {
              return DropdownMenuItem(
                child: new Text(timezone),
                value: timezone,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
