import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/bookings_model.dart';

class BookingController extends ChangeNotifier {
  Box<dynamic> _db;

  BookingController(Box<dynamic> db) {
    _db = db;
  }

  /// Add/Update booking to hive db
  void add(BookingsModel item, String key) {
    _db.put(key, item);
    notifyListeners();
  }

  /// Get All bookings from hive by date
  List<BookingsModel> getAll(DateTime date) {
    final DateFormat format = DateFormat('yyyy-MM-dd');
    final String formattedDate = format.format(date);
    return _db.values
        .where((val) => format.format(val.dateTime) == formattedDate)
        .toList();
  }

  /// Delete booking from hive by date
  void del(String key) {
    _db.delete(key);
    notifyListeners();
  }
}
