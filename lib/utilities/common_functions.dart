import 'package:flutter/material.dart';

enum BookingPriority { high, medium, low }
enum DropDownType { duration, meetingRoom, priority }

extension DateTimeExtension on DateTime {
  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

class CommonFunctions {
  static final CommonFunctions _singleton = CommonFunctions();
  static CommonFunctions get instance => _singleton;

  /// Convert duration to string
  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')} hour : ${parts[1].padLeft(2, '0')} minutes';
  }

  /// Common textfield view to be used throughout the app
  Widget commonTextFieidView(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        decoration: InputDecoration(
            hintText: title,
            hintStyle:
                TextStyle(fontWeight: FontWeight.w300, color: Colors.black87)),
        controller: controller,
      ),
    );
  }

  /// Common SnackBar view to be used throughout the app
  void showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: new Text(message),
      ),
    );
  }
}
