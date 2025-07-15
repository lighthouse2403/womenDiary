import 'package:flutter/material.dart';

enum CalendarDatePicker2Type { single, multi, range }

typedef CalendarDayTextStylePredicate = TextStyle? Function({
  required DateTime date,
});

typedef CalendarDayBuilder = Widget? Function({
  required DateTime date,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isToday,
});

typedef CalendarYearBuilder = Widget? Function({
  required int year,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isCurrentYear,
});

typedef CalendarModePickerTextHandler = String? Function({
  required DateTime monthDate,
});

class CalendarDatePicker2Config {
  CalendarDatePicker2Config({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    this.weekdayLabels,
    this.weekdayLabelTextStyle,
    this.firstDayOfWeek,
    this.controlsHeight,
    this.lastMonthIcon,
    this.nextMonthIcon,
    this.controlsTextStyle,
    this.dayTextStyle,
    this.selectedDayTextStyle,
    this.selectedDayHighlightColor,
    this.selectedRangeHighlightColor,
    this.disabledDayTextStyle,
    this.todayTextStyle,
    this.yearTextStyle,
    this.selectedYearTextStyle,
    this.dayBorderRadius,
    this.yearBorderRadius,
    this.selectableDayPredicate,
    this.dayTextStylePredicate,
    this.dayBuilder,
    this.yearBuilder,
    this.disableModePicker,
    this.centerAlignModePicker,
    this.customModePickerIcon,
    this.modePickerTextHandler,
    this.selectedRangeDayTextStyle,
  })  : calendarType = calendarType ?? CalendarDatePicker2Type.single,
        firstDate = DateUtils.dateOnly(firstDate ?? DateTime(1970)),
        lastDate =
            DateUtils.dateOnly(lastDate ?? DateTime(DateTime.now().year + 50)),
        currentDate = currentDate ?? DateUtils.dateOnly(DateTime.now()),
        calendarViewMode = calendarViewMode ?? DatePickerMode.day;

  final CalendarDatePicker2Type calendarType;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime currentDate;

  final DatePickerMode calendarViewMode;

  final List<String>? weekdayLabels;

  final TextStyle? weekdayLabelTextStyle;

  final int? firstDayOfWeek;

  final double? controlsHeight;

  final Widget? lastMonthIcon;

  final Widget? nextMonthIcon;

  final TextStyle? controlsTextStyle;

  final TextStyle? dayTextStyle;

  final TextStyle? selectedDayTextStyle;

  final TextStyle? selectedRangeDayTextStyle;

  final Color? selectedDayHighlightColor;

  final Color? selectedRangeHighlightColor;

  final TextStyle? disabledDayTextStyle;

  final TextStyle? todayTextStyle;

  final TextStyle? yearTextStyle;

  final TextStyle? selectedYearTextStyle;

  final BorderRadius? dayBorderRadius;

  final BorderRadius? yearBorderRadius;

  final SelectableDayPredicate? selectableDayPredicate;

  final CalendarDayTextStylePredicate? dayTextStylePredicate;

  final CalendarDayBuilder? dayBuilder;

  final CalendarYearBuilder? yearBuilder;

  final bool? disableModePicker;

  final bool? centerAlignModePicker;

  final Widget? customModePickerIcon;

  final CalendarModePickerTextHandler? modePickerTextHandler;

  CalendarDatePicker2Config copyWith({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    Widget? nextMonthIcon,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
    Color? selectedRangeHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    TextStyle? selectedRangeDayTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    SelectableDayPredicate? selectableDayPredicate,
    CalendarDayTextStylePredicate? dayTextStylePredicate,
    CalendarDayBuilder? dayBuilder,
    CalendarYearBuilder? yearBuilder,
    bool? disableModePicker,
    bool? centerAlignModePicker,
    Widget? customModePickerIcon,
    CalendarModePickerTextHandler? modePickerTextHandler,
  }) {
    return CalendarDatePicker2Config(
      calendarType: calendarType ?? this.calendarType,
      firstDate: DateUtils.dateOnly(firstDate ?? this.firstDate),
      lastDate: DateUtils.dateOnly(lastDate ?? this.lastDate),
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      weekdayLabels: weekdayLabels ?? this.weekdayLabels,
      weekdayLabelTextStyle:
          weekdayLabelTextStyle ?? this.weekdayLabelTextStyle,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      selectedDayHighlightColor:
          selectedDayHighlightColor ?? this.selectedDayHighlightColor,
      selectedRangeHighlightColor:
          selectedRangeHighlightColor ?? this.selectedRangeHighlightColor,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      yearTextStyle: yearTextStyle ?? this.yearTextStyle,
      selectedYearTextStyle:
          selectedYearTextStyle ?? this.selectedYearTextStyle,
      selectedRangeDayTextStyle:
          selectedRangeDayTextStyle ?? this.selectedRangeDayTextStyle,
      dayBorderRadius: dayBorderRadius ?? this.dayBorderRadius,
      yearBorderRadius: yearBorderRadius ?? this.yearBorderRadius,
      selectableDayPredicate:
          selectableDayPredicate ?? this.selectableDayPredicate,
      dayTextStylePredicate:
          dayTextStylePredicate ?? this.dayTextStylePredicate,
      dayBuilder: dayBuilder ?? this.dayBuilder,
      yearBuilder: yearBuilder ?? this.yearBuilder,
      disableModePicker: disableModePicker ?? this.disableModePicker,
      centerAlignModePicker:
          centerAlignModePicker ?? this.centerAlignModePicker,
      customModePickerIcon: customModePickerIcon ?? this.customModePickerIcon,
      modePickerTextHandler:
          modePickerTextHandler ?? this.modePickerTextHandler,
    );
  }
}

class CalendarDatePicker2WithActionButtonsConfig
    extends CalendarDatePicker2Config {
  CalendarDatePicker2WithActionButtonsConfig({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    Widget? nextMonthIcon,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
    Color? selectedRangeHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    TextStyle? selectedRangeDayTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    SelectableDayPredicate? selectableDayPredicate,
    CalendarDayTextStylePredicate? dayTextStylePredicate,
    CalendarDayBuilder? dayBuilder,
    CalendarYearBuilder? yearBuilder,
    bool? disableModePicker,
    bool? centerAlignModePicker,
    Widget? customModePickerIcon,
    CalendarModePickerTextHandler? modePickerTextHandler,
    this.gapBetweenCalendarAndButtons,
    this.cancelButtonTextStyle,
    this.cancelButton,
    this.okButtonTextStyle,
    this.okButton,
    this.openedFromDialog,
    this.closeDialogOnCancelTapped,
    this.closeDialogOnOkTapped,
    this.buttonPadding,
  }) : super(
          calendarType: calendarType,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          calendarViewMode: calendarViewMode,
          weekdayLabels: weekdayLabels,
          weekdayLabelTextStyle: weekdayLabelTextStyle,
          firstDayOfWeek: firstDayOfWeek,
          controlsHeight: controlsHeight,
          lastMonthIcon: lastMonthIcon,
          nextMonthIcon: nextMonthIcon,
          controlsTextStyle: controlsTextStyle,
          dayTextStyle: dayTextStyle,
          selectedDayTextStyle: selectedDayTextStyle,
          selectedRangeDayTextStyle: selectedRangeDayTextStyle,
          selectedDayHighlightColor: selectedDayHighlightColor,
          selectedRangeHighlightColor: selectedRangeHighlightColor,
          disabledDayTextStyle: disabledDayTextStyle,
          todayTextStyle: todayTextStyle,
          yearTextStyle: yearTextStyle,
          selectedYearTextStyle: selectedYearTextStyle,
          dayBorderRadius: dayBorderRadius,
          yearBorderRadius: yearBorderRadius,
          selectableDayPredicate: selectableDayPredicate,
          dayTextStylePredicate: dayTextStylePredicate,
          dayBuilder: dayBuilder,
          yearBuilder: yearBuilder,
          disableModePicker: disableModePicker,
          centerAlignModePicker: centerAlignModePicker,
          customModePickerIcon: customModePickerIcon,
          modePickerTextHandler: modePickerTextHandler,
        );

  /// The gap between calendar and action buttons
  final double? gapBetweenCalendarAndButtons;

  /// Text style for cancel button
  final TextStyle? cancelButtonTextStyle;

  /// Custom cancel button
  final Widget? cancelButton;

  /// Text style for ok button
  final TextStyle? okButtonTextStyle;

  /// Custom ok button
  final Widget? okButton;

  /// Is the calendar opened from dialog
  final bool? openedFromDialog;

  /// If the dialog should be closed when user taps the CANCEL button
  final bool? closeDialogOnCancelTapped;

  /// If the dialog should be closed when user taps the OK button
  final bool? closeDialogOnOkTapped;

  /// Custom wrapping padding for Ok & Cancel buttons
  final EdgeInsets? buttonPadding;

  @override
  CalendarDatePicker2WithActionButtonsConfig copyWith({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    Widget? nextMonthIcon,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    TextStyle? selectedRangeDayTextStyle,
    Color? selectedDayHighlightColor,
    Color? selectedRangeHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    SelectableDayPredicate? selectableDayPredicate,
    CalendarDayTextStylePredicate? dayTextStylePredicate,
    CalendarDayBuilder? dayBuilder,
    CalendarYearBuilder? yearBuilder,
    bool? disableModePicker,
    bool? centerAlignModePicker,
    Widget? customModePickerIcon,
    CalendarModePickerTextHandler? modePickerTextHandler,
    double? gapBetweenCalendarAndButtons,
    TextStyle? cancelButtonTextStyle,
    Widget? cancelButton,
    TextStyle? okButtonTextStyle,
    Widget? okButton,
    bool? openedFromDialog,
    bool? closeDialogOnCancelTapped,
    bool? closeDialogOnOkTapped,
    EdgeInsets? buttonPadding,
  }) {
    return CalendarDatePicker2WithActionButtonsConfig(
      calendarType: calendarType ?? this.calendarType,
      firstDate: DateUtils.dateOnly(firstDate ?? this.firstDate),
      lastDate: DateUtils.dateOnly(lastDate ?? this.lastDate),
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      weekdayLabels: weekdayLabels ?? this.weekdayLabels,
      weekdayLabelTextStyle:
          weekdayLabelTextStyle ?? this.weekdayLabelTextStyle,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      selectedRangeDayTextStyle:
          selectedRangeDayTextStyle ?? this.selectedRangeDayTextStyle,
      selectedDayHighlightColor:
          selectedDayHighlightColor ?? this.selectedDayHighlightColor,
      selectedRangeHighlightColor:
          selectedRangeHighlightColor ?? this.selectedRangeHighlightColor,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      yearTextStyle: yearTextStyle ?? this.yearTextStyle,
      selectedYearTextStyle:
          selectedYearTextStyle ?? this.selectedYearTextStyle,
      dayBorderRadius: dayBorderRadius ?? this.dayBorderRadius,
      yearBorderRadius: yearBorderRadius ?? this.yearBorderRadius,
      selectableDayPredicate:
          selectableDayPredicate ?? this.selectableDayPredicate,
      dayTextStylePredicate:
          dayTextStylePredicate ?? this.dayTextStylePredicate,
      dayBuilder: dayBuilder ?? this.dayBuilder,
      yearBuilder: yearBuilder ?? this.yearBuilder,
      disableModePicker: disableModePicker ?? this.disableModePicker,
      centerAlignModePicker:
          centerAlignModePicker ?? this.centerAlignModePicker,
      customModePickerIcon: customModePickerIcon ?? this.customModePickerIcon,
      modePickerTextHandler:
          modePickerTextHandler ?? this.modePickerTextHandler,
      gapBetweenCalendarAndButtons:
          gapBetweenCalendarAndButtons ?? this.gapBetweenCalendarAndButtons,
      cancelButtonTextStyle:
          cancelButtonTextStyle ?? this.cancelButtonTextStyle,
      cancelButton: cancelButton ?? this.cancelButton,
      okButtonTextStyle: okButtonTextStyle ?? this.okButtonTextStyle,
      okButton: okButton ?? this.okButton,
      openedFromDialog: openedFromDialog ?? this.openedFromDialog,
      closeDialogOnCancelTapped:
          closeDialogOnCancelTapped ?? this.closeDialogOnCancelTapped,
      closeDialogOnOkTapped:
          closeDialogOnOkTapped ?? this.closeDialogOnOkTapped,
      buttonPadding: buttonPadding ?? this.buttonPadding,
    );
  }
}
