import 'package:flutter/material.dart';
import 'package:women_diary/common/widgets/date_picker/multi_range_calendar.dart';

class MenstruationCalendar extends StatelessWidget {
  const MenstruationCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiRangeCalendar(
        initialRanges: [
          DateTimeRange(
              start: DateTime(2025, 7, 10), end: DateTime(2025, 7, 14)),
          DateTimeRange(
              start: DateTime(2025, 7, 18), end: DateTime(2025, 7, 20)),
        ],
        onChanged: (ranges) {
          print("Ranges: $ranges");
        },
      ),
    );
  }
}
