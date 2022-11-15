import 'package:intl/intl.dart';

class Helper {
  static String FormatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }
    return DateFormat('dd MMMM yyyy - hh:mm', 'tr').format(dateTime);
  }
}
