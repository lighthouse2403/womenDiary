import 'package:flutter/material.dart';
import 'package:baby_diary/_gen/assets.gen.dart';
import 'package:baby_diary/common/base/base_child_stateful_widget.dart';
import 'package:baby_diary/common/constants/constants.dart';
import 'package:baby_diary/common/extension/font_size_extension.dart';
import 'package:baby_diary/common/extension/font_weight_extension.dart';
import 'package:baby_diary/common/extension/text_color_extension.dart';
import 'package:baby_diary/common/widgets/date_picker/src/models/calendar_date_picker2_config.dart';

import 'src/widgets/calendar_date_picker2_with_action_buttons.dart';

class TimePicker extends StatefulWidget {

  TimePicker({super.key, required this.singleDatePickerValueWithDefaultValue, required this.changedDateFilter});

  List<DateTime?> singleDatePickerValueWithDefaultValue = [DateTime.now()];

  final Function(DateTime?) changedDateFilter;
  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return _buildCalendarWithActionButtons();
  }

  Widget _buildCalendarWithActionButtons() {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.single,
      yearTextStyle: const TextStyle().textW500().text14().primaryTextColor(),
      dayTextStyle: const TextStyle().textW400().text14().primaryTextColor(),
      customModePickerIcon: Container(
          child: Assets.icons.alarm.svg(
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(Constants.primaryTextColor(), BlendMode.srcIn)
          )
      ),
      gapBetweenCalendarAndButtons: 10,
      nextMonthIcon: Container(
          child: Assets.icons.alarm.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(Constants.primaryTextColor(), BlendMode.srcIn)
          )
      ),
      lastMonthIcon: Container(
          child: Assets.icons.alarm.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(Constants.primaryTextColor(), BlendMode.srcIn)
          )
      ),
    );
    return Container(
      height: double.infinity,
      color: Constants.secondaryTextColor().withOpacity(0.4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarDatePicker2WithActionButtons(
            config: config,
            value: widget.singleDatePickerValueWithDefaultValue,
            onValueChanged: (dates) {
              widget.singleDatePickerValueWithDefaultValue = dates;
            },
            onOkTapped: () {
              widget.changedDateFilter(widget.singleDatePickerValueWithDefaultValue.firstOrNull);
            },
            onCancelTapped: () {
              widget.changedDateFilter(null);
            },
          ),
          Expanded(
              child: InkWell(
                onTap: () {
                  widget.changedDateFilter(null);
                },
                child: Container(
                  color: Colors.transparent,
                ),
              )
          )
        ],
      ),
    );
  }
}



