import 'package:flutter/material.dart';
import 'package:baby_diary/common/constants/constants.dart';
import 'package:baby_diary/common/extension/text_extension.dart';
import 'package:baby_diary/common/widgets/date_picker/src/models/calendar_date_picker2_config.dart';
import 'package:baby_diary/common/widgets/date_picker/src/widgets/calendar_date_picker2.dart';

class CalendarDatePicker2WithActionButtons extends StatefulWidget {
  const CalendarDatePicker2WithActionButtons({
    required this.value,
    required this.config,
    this.onValueChanged,
    this.onDisplayedMonthChanged,
    this.onCancelTapped,
    this.onOkTapped,
    Key? key,
  }) : super(key: key);

  final List<DateTime?> value;

  final ValueChanged<List<DateTime?>>? onValueChanged;

  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  final CalendarDatePicker2WithActionButtonsConfig config;

  final Function? onCancelTapped;

  final Function? onOkTapped;

  @override
  State<CalendarDatePicker2WithActionButtons> createState() =>
      _CalendarDatePicker2WithActionButtonsState();
}

class _CalendarDatePicker2WithActionButtonsState
    extends State<CalendarDatePicker2WithActionButtons> {
  List<DateTime?> _values = [];
  List<DateTime?> _editCache = [];

  @override
  void initState() {
    _values = widget.value;
    _editCache = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(
      covariant CalendarDatePicker2WithActionButtons oldWidget) {
    var isValueSame = oldWidget.value.length == widget.value.length;

    if (isValueSame) {
      for (var i = 0; i < oldWidget.value.length; i++) {
        var isSame = (oldWidget.value[i] == null && widget.value[i] == null) ||
            DateUtils.isSameDay(oldWidget.value[i], widget.value[i]);
        if (!isSame) {
          isValueSame = false;
          break;
        }
      }
    }

    if (!isValueSame) {
      _values = widget.value;
      _editCache = widget.value;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MediaQuery.removePadding(
            context: context,
            child: CalendarDatePicker2(
              value: [..._editCache],
              config: widget.config,
              onValueChanged: (values) => _editCache = values,
              onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
            ),
          ),
          Container(height: 1, color: Constants.mainColor()),
          Container(
            height: 68,
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCancelButton(),
                if ((widget.config.gapBetweenCalendarAndButtons ?? 0) > 0)
                  SizedBox(width: widget.config.gapBetweenCalendarAndButtons),
                _buildOkButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        _editCache = _values;
        widget.onCancelTapped?.call();
        if ((widget.config.openedFromDialog ?? false) &&
            (widget.config.closeDialogOnCancelTapped ?? true)) {
          Navigator.pop(context);
        }
      }),
      child: Container(
        padding: widget.config.buttonPadding ??
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: widget.config.cancelButton ??
            Text(
              'Huỷ',
              style: widget.config.cancelButtonTextStyle ??
                  TextStyle(
                    color: widget.config.selectedDayHighlightColor ?? Constants.primaryTextColor(),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
            ),
      ),
    );
  }

  Widget _buildOkButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        _values = _editCache;
        widget.onValueChanged?.call(_values);
        widget.onOkTapped?.call();
        if ((widget.config.openedFromDialog ?? false) &&
            (widget.config.closeDialogOnOkTapped ?? true)) {
          Navigator.pop(context, _values);
        }
      }),
      child: Container(
        padding: widget.config.buttonPadding ??
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: widget.config.okButton ??
            Text(
              'OK',
              style: widget.config.okButtonTextStyle ??
                  TextStyle(
                    color: widget.config.selectedDayHighlightColor ?? Constants.primaryTextColor(),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
            ),
      ),
    );
  }
}
