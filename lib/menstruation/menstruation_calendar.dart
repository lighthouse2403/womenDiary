import 'package:flutter/material.dart';
import 'package:women_diary/common/widgets/date_picker/multi_range_calendar.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';

class MenstruationCalendar extends StatefulWidget {
  const MenstruationCalendar({super.key});

  @override
  State<MenstruationCalendar> createState() => _MenstruationCalendarState();
}

class _MenstruationCalendarState extends State<MenstruationCalendar> {
  List<MenstruationModel> menstruation = [];

  @override
  initState() {
    loadInitialData();
    super.initState();
  }

  loadInitialData() async {
    menstruation = await DatabaseHandler.getAllMenstruation();
    print(menstruation.length);
  }

  @override
  Widget build(BuildContext context) {
    List<DateTimeRange> initialRange = menstruation.map((e) {
      return DateTimeRange(start: e.startTime, end: e.endTime);
    }).toList();
    return Scaffold(
      body: MultiRangeCalendar(
        initialRanges: initialRange,
        onAddRange: (range) {
          print(range.start);
          MenstruationModel menstruation = MenstruationModel.init(range.start, range.end);
          DatabaseHandler.insertMenstruation(menstruation);
        },
        onDeleteRange: (ranges) {
          ranges.forEach((range) {
            DatabaseHandler.deleteMenstruation(range.start.millisecondsSinceEpoch, range.end.millisecondsSinceEpoch);
          });
        },
      ),
    );
  }
}
