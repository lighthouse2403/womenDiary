import 'package:flutter/material.dart';
import 'package:women_diary/common/widgets/date_picker/src/models/calendar_date_picker2_config.dart';
import 'package:women_diary/common/widgets/date_picker/src/utils/date_util.dart';
import 'package:women_diary/common/widgets/date_picker/src/widgets/calendar_date_picker2_with_action_buttons.dart';

final today = DateUtils.dateOnly(DateTime.now());

class MenstruationCalendar extends StatefulWidget {
  const MenstruationCalendar({ Key? key }) : super(key: key);

  @override
  State<MenstruationCalendar> createState() => _MenstruationCalendarState();
}

class _MenstruationCalendarState extends State<MenstruationCalendar> {
  final _scrollController = ScrollController();

  List<DateTime?> _rangeDatePickerWithActionButtonsWithValue = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 5)),
  ];

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 1000) {
        print('scrolling distance: ${_scrollController.offset}');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
            child: _buildScrollCalendarWithActionButtons(),
          )
      ),
    );
  }

  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
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
          const Text('Date Picker With Action Buttons'),
          CalendarDatePicker2WithActionButtons(
            config: config,
            value: _rangeDatePickerWithActionButtonsWithValue,
            onValueChanged: (dates) => setState(
                    () => _rangeDatePickerWithActionButtonsWithValue = dates),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Selection(s):  '),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  _getValueText(
                    config.calendarType,
                    _rangeDatePickerWithActionButtonsWithValue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
