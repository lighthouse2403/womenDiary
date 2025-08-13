import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String _dateFormat(String dateFormat) {
    return DateFormat(dateFormat).format(this);
  }

  String globalDateFormat() {
    String dateFormat = 'dd-MM-yyyy';
    return _dateFormat(dateFormat);
  }

  String globalDateTimeFormat() {
    String dateFormat = 'HH:mm:ss dd-MM-yyyy';
    return _dateFormat(dateFormat);
  }


  String globalMonthFormat(String language) {
    return DateFormat('MMMM yyyy', language).format(this);
  }

  String globalTimeFormat() {
    String dateFormat = 'HH:mm';
    return _dateFormat(dateFormat);
  }

  DateTime startOfDay() {
    return DateTime(year, month, day, 0,0,0);
  }

  DateTime convertFromBirthDateToLastPeriod() {
    return subtract(const Duration(days: 280));
  }

  int convertFromBirthDateToRemainDay() {
    return (difference(DateTime.now()).inHours / 24).round();
  }

  int convertFromBirthDateToBabyAge() {
    DateTime lastPeriod = convertFromBirthDateToLastPeriod();
    return (DateTime.now().difference(lastPeriod).inHours / 24).round();
  }

  DateTime convertFromLastPeriodToBirthDate() {
    return add(const Duration(days: 280));
  }

  String generateDurationTime() {
    Duration duration = DateTime.now().difference(this);

    String durationString = '';
    int months = duration.inDays ~/ 30;
    int year = months ~/ 12;
    String unit = '';

    if (year > 0) {
      durationString = '$year';
      unit = 'năm';
    } else if (months > 0) {
      durationString = '$months';
      unit = 'tháng';
    } else if (duration.inDays > 0) {
      durationString = '${duration.inDays}';
      unit = 'ngày';
    } else if (duration.inHours > 0) {
      durationString = '${duration.inHours}';
      unit = 'giờ';
    } else if (duration.inMinutes > 0) {
      durationString = '${duration.inMinutes}';
      unit = 'phút';
    } else {
      durationString = 'Bây giờ';
    }
    return '$durationString $unit';
  }
}
