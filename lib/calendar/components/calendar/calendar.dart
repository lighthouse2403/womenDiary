import 'package:flutter/material.dart';
import 'package:baby_diary/calendar/components/calendar/day.dart';
import 'package:baby_diary/calendar/components/calendar/day_of_week.dart';
import 'package:baby_diary/calendar/components/calendar/header.dart';
import 'package:baby_diary/calendar/components/calendar/utils.dart';
import 'package:baby_diary/calendar/components/swipe_detector.dart';
import 'package:baby_diary/common/constants/constants.dart';

class Calendar extends StatefulWidget {
  final List<DateTime> markedDays;
  final Function onDateTimeChanged;
  const Calendar({super.key, required this.markedDays, required this.onDateTimeChanged});

  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>  with TickerProviderStateMixin  {
  DateTime calendar = DateTime.now();
  DateTime selectedDate = DateTime.now() ;

  //animation
  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;


  @override
  void initState() {
    calendar = DateTime.now();

    //animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _offsetFloat = Tween<Offset>(begin: const Offset(1, 0.0), end: Offset.zero)
        .animate(_controller);

    _controller.forward();
  }

  Widget getDateOfWeekHeader(dayWidth) {
    List<Widget> listDay = [];
    for (int i = 0; i < Constants.days.length; i++) {
      listDay.add(DayOfWeek(Constants.days[i], dayWidth));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: listDay,
    );
  }

  Widget getMonthComponent(context) {
    var width = MediaQuery.of(context).size.width;
    var dayWidth = width / 7;

    int year = calendar.year;
    int month = calendar.month;
    var lastDayMonth = lastDayOfMonth(calendar);
    List<Widget> rowItems = [];
    List<Widget> columnItems = [
      getDateOfWeekHeader(dayWidth),
    ];
    var numItem = 0;
    // first day of month
    DateTime firstDayOfTheMonth = firstDayOfWeek(DateTime(year, month, 1));
    if (firstDayOfTheMonth.day > 1) {
      //previous month
      DateTime lastDayPreMonth = lastDayOfPreviousMonth(calendar);
      for (int i = firstDayOfTheMonth.day; i <= lastDayPreMonth.day; i++) {
        numItem++;
        Day day = Day(
            width: dayWidth,
            date: DateTime(firstDayOfTheMonth.year, firstDayOfTheMonth.month, i),
            currentCalendar: calendar,
            selectedDate: selectedDate,
            onDayPress: onDayPress,
            markedDays: widget.markedDays);
        rowItems.add(day);
      }
    }
    for (int i = 1; i <= lastDayMonth.day; i++) {
      //current month
      numItem++;
      Day day = Day(
          width: dayWidth,
          date: DateTime(calendar.year, calendar.month, i),
          currentCalendar: calendar,
          selectedDate: selectedDate,
          onDayPress: onDayPress,
          markedDays: widget.markedDays);
      rowItems.add(day);
      if (numItem % 7 == 0) {
        columnItems.add(Row(children: rowItems));
        rowItems = [];
      }
    }
    //next month
    var endDayWeek =
        endDayOfWeek(DateTime(calendar.year, calendar.month, lastDayMonth.day));
    if (endDayWeek.day < 10) {
      // have next month
      for (int i = 1; i <= endDayWeek.day; i++) {
        //current month
        numItem++;
        Day day = Day(
            width: dayWidth,
            date: DateTime(endDayWeek.year, endDayWeek.month, i),
            currentCalendar: calendar,
            selectedDate: selectedDate,
            onDayPress: onDayPress,
            markedDays: widget.markedDays);
        rowItems.add(day);
        if (numItem % 7 == 0) {
          columnItems.add(Row(children: rowItems));
          rowItems = [];
        }
      }
    }
    if (rowItems.isNotEmpty) {
      columnItems.add(Row(children: rowItems));
    }

    return SizedBox(
      child: SlideTransition(
        position: _offsetFloat,
        child: SwipeDetector(
            child: Column(children: columnItems),
          onSwipeLeft: (){
              onPreviousPress();
          },
          onSwipeRight: (){
              onNextPress();
          },
        ),
      ),
    );
  }

  onDayPress(date) {
    setState(() {
      selectedDate = date;
    });
    if (isOtherMonth(date, calendar)) {
      setState(() {
        calendar = date;
      });
    }
  }

  onPreviousPress() {
    var newCalendar = decreaseMonth(calendar);
    setState(() {
      calendar = newCalendar;
    });
    onChangeMonth(newCalendar);
    _offsetFloat = Tween<Offset>(begin: Offset(-1, 0.0), end: Offset.zero)
        .animate(_controller);
    _controller.value = 0.0;
    _controller.forward();
  }

  onNextPress() {
    var newCalendar = increaseMonth(calendar);
    setState(() {
      calendar = newCalendar;
    });
    onChangeMonth(newCalendar);
    _offsetFloat = Tween<Offset>(begin: const Offset(1, 0.0), end: Offset.zero)
        .animate(_controller);
    _controller.value = 0.0;
    _controller.forward();
  }

  onChangeMonth(DateTime newCalendar) {
    widget.onDateTimeChanged(newCalendar);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: <Widget>[
          Header(
            currentMonth: calendar,
            onPreviousPress: onPreviousPress,
            onNextPress: onNextPress,
          ),
          getMonthComponent(context),
        ],
      ),
    );
  }
}
