import 'package:flutter/material.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/widgets/date_picker/multi_range_calendar.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/data_handler.dart';

class CycleCalendar extends StatefulWidget {
  CycleCalendar({super.key, required this.cycle});
  final List<CycleModel> cycle;

  @override
  State<CycleCalendar> createState() => _CycleCalendarState();
}

class _CycleCalendarState extends State<CycleCalendar> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTimeRange> initialRange = widget.cycle.map((e) {
      return DateTimeRange(start: e.cycleStartTime, end: e.cycleEndTime);
    }).toList();
    return MultiRangeCalendar(
      initialRanges: initialRange,
      onAddRange: (range) {
        print(range.start);
        CycleModel cycle = CycleModel.startCycle(range.start.startOfDay(), range.end.startOfDay(),);
        DatabaseHandler.insertCycle(cycle);
      },
      onDeleteRange: (ranges) {
        ranges.forEach((range) {
          DatabaseHandler.deleteCycle(range.start.startOfDay().millisecondsSinceEpoch);
        });
      },
    );
  }
}
