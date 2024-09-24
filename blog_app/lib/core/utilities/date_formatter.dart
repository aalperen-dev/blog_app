import 'package:intl/intl.dart';

class AppDateFormatter {
  static String formatDateBydMMMYYYY(DateTime dateTime) {
    return DateFormat("d MMM, yyyy").format(dateTime);
  }
}
