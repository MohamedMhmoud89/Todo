import 'package:intl/intl.dart';

class MyDateUtils {
  static String formatTaskDate(DateTime dateTime) {
    var formatter = DateFormat("yyyy/MM/dd");
    return formatter.format(dateTime);
  }

  static DateTime dateOnly(DateTime input) {
    return DateTime(input.year, input.month, input.day);
  }
}
