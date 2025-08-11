import 'package:flutter/material.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/widgets/date_picker/multi_range_calendar.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';

class MenstruationCalendar extends StatefulWidget {
  MenstruationCalendar({super.key, required this.menstruation});
  final List<MenstruationModel> menstruation;

  @override
  State<MenstruationCalendar> createState() => _MenstruationCalendarState();
}

class _MenstruationCalendarState extends State<MenstruationCalendar> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTimeRange> initialRange = widget.menstruation.map((e) {
      return DateTimeRange(start: e.startTime, end: e.endTime);
    }).toList();
    return Scaffold(
      body: MultiRangeCalendar(
        initialRanges: initialRange,
        onAddRange: (range) {
          print(range.start);
          MenstruationModel menstruation = MenstruationModel.init(range.start.startOfDay(), range.end.startOfDay());
          DatabaseHandler.insertMenstruation(menstruation);
        },
        onDeleteRange: (ranges) {
          ranges.forEach((range) {
            DatabaseHandler.deleteMenstruation(range.start.startOfDay().millisecondsSinceEpoch, range.end.startOfDay().millisecondsSinceEpoch);
          });
        },
      ),
    );
  }
}
