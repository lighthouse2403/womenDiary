import 'package:intl/intl.dart';

extension StringExtensionNullable on String? {
  DateTime convertToDateTime(String formatDate) {
    try {
      final date = this;
      if (date == null) {
        return DateTime.now();
      }

      final time = DateFormat(formatDate).parse(date);

      return time;
    } catch (exception) {
    }
    return DateTime.now();
  }

  DateTime convertToDefaultDateTime() {
    try {
      final date = this;
      if (date == null) {
        return DateTime.now();
      }

      final time = DateFormat('HH:mm:ss dd-MM-yyyy').parse(date);

      return time;
    } catch (exception) {
    }
    return DateTime.now();
  }
}
