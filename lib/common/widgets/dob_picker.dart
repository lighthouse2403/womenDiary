import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/font_size_extension.dart';
import 'package:women_diary/common/extension/font_weight_extension.dart';
import 'package:women_diary/common/extension/text_color_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/common/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/common/widgets/date_picker/src/models/calendar_date_picker2_config.dart';
import 'package:women_diary/common/widgets/date_picker/src/widgets/calendar_date_picker2.dart';
import '../constants/app_colors.dart';

class DobPicker extends StatelessWidget {
  final DateTime selectedDob;
  final Function(DateTime) onDobChanged;

  const DobPicker({
    super.key,
    required this.selectedDob,
    required this.onDobChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text('Date of birth').w500().text14().mainColor(),
          Constants.hSpacer12,
          Expanded(
            child: CommonButton(
              textStyle: const TextStyle().textW500().text14().mainColor(),
              backgroundColor: AppColors.disableColor.withAlpha(40),
              buttonText: selectedDob.globalDateFormat(),
              onClick: () async {
                final date = await showCustomDatePicker(context, selectedDob);
                if (date != null) {
                  onDobChanged(date);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

Future<DateTime?> showCustomDatePicker(BuildContext context, DateTime initialDate) async {
  DateTime? selectedDate = initialDate;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Chọn ngày'),
        content: CalendarDatePicker2(
          config: CalendarDatePicker2Config(),
          value: [initialDate],
          onValueChanged: (dates) {
            selectedDate = dates.first;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Xong'),
          ),
        ],
      );
    },
  );

  return selectedDate;
}
