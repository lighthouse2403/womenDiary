import 'package:flutter/material.dart';
import 'package:women_diary/common/widgets/date_picker/src/models/calendar_date_picker2_config.dart';
import 'package:women_diary/common/widgets/date_picker/src/utils/date_util.dart';
import 'package:women_diary/common/widgets/date_picker/src/widgets/calendar_date_picker2_with_action_buttons.dart';

final today = DateUtils.dateOnly(DateTime.now());

class MenstruationCalendar extends StatefulWidget {
  const MenstruationCalendar({Key? key}) : super(key: key);

  @override
  State<MenstruationCalendar> createState() => _MenstruationCalendarState();
}

class _MenstruationCalendarState extends State<MenstruationCalendar> {
  final _scrollController = ScrollController();

  // Danh sách các khoảng đã chọn
  List<List<DateTime?>> _rangeList = [
    [DateTime.now(), DateTime.now().add(const Duration(days: 5))],
  ];

  // Range hiện tại đang chọn
  List<DateTime?> _currentRangeDraft = [];

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 1000) {
        print('scrolling distance: ${_scrollController.offset}');
      }
    });
    super.initState();
  }

  Widget _buildScrollCalendarWithActionButtons() {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      calendarViewMode: CalendarDatePicker2Mode.scroll,
      rangeBidirectional: true,
      scrollViewConstraints: const BoxConstraints(maxHeight: 800),
      scrollViewMonthYearBuilder: (monthDate) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 11, 69, 117),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Text(
                    getLocaleShortMonthFormat(const Locale('en'))
                        .format(monthDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    monthDate.year.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      hideScrollViewMonthWeekHeader: true,
      disableModePicker: true,
    );

    return SizedBox(
      width: 375,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text('Chọn khoảng ngày'),
          CalendarDatePicker2WithActionButtons(
            config: config,
            value: _currentRangeDraft,
            onValueChanged: (dates) {
              setState(() {
                _currentRangeDraft = dates;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_currentRangeDraft.length == 2 &&
                  _currentRangeDraft[0] != null &&
                  _currentRangeDraft[1] != null) {
                setState(() {
                  _rangeList.add([..._currentRangeDraft]);
                  _currentRangeDraft = [];
                });
              }
            },
            child: const Text("Thêm khoảng mới"),
          ),
          const SizedBox(height: 20),
          const Text('Các khoảng đã chọn:', style: TextStyle(fontWeight: FontWeight.bold)),
          ..._rangeList.map((range) {
            final start = range[0]?.toString().split(' ')[0] ?? '';
            final end = range[1]?.toString().split(' ')[0] ?? '';
            return Text('- $start đến $end');
          }).toList(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: _buildScrollCalendarWithActionButtons(),
        ),
      ),
    );
  }
}
