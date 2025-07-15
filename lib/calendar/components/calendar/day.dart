import 'package:flutter/material.dart';
import 'package:baby_diary/calendar/components/calendar/dot.dart';
import 'package:baby_diary/calendar/components/calendar/utils.dart';
import 'package:baby_diary/calendar/utils/lunar_solar_utils.dart';
import 'package:baby_diary/common/constants/constants.dart';

class Day extends StatelessWidget {
  final double width;
  final DateTime date;
  final DateTime selectedDate;
  final DateTime currentCalendar;
  final Function onDayPress;
  final List<DateTime> markedDays;

  Day({
    required this.width,
    required this.date,
    required this.currentCalendar,
    required this.selectedDate,
    required this.onDayPress,
    required this.markedDays,
  });

  bool checkMarked() {
    bool marked = false;
    for (var element in markedDays) {
      if (element.day == date.day && element.month == date.month) {
        marked = true;
      }
    }
    return marked;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var notInMainCalendar = false;
    DateTime now = DateTime.now();
    var lunarDay = convertSolar2Lunar(date.day, date.month, date.year, 7)[0];
    //box color, text color
    var boxColor = Colors.transparent;
    Color dotColor = Constants.DOT_COLOR;
    var textColor = Constants.DAY_TEXT_NORMAL;
    if (isOtherMonth(date, currentCalendar)) {
      // is other month
      notInMainCalendar = true;
    }
    if (equalDate(now, date)) {
      boxColor = Constants.BOX_TODAY_COLOR;
      textColor = Constants.DAY_TEXT_SELECTED;
    }
    if (equalDate(selectedDate, date)) {
      boxColor = Constants.BOX_SELECTED_COLOR;
      textColor = Constants.DAY_TEXT_SELECTED;
    }
    var isShowDot = checkMarked();
    //dot color
    if (boxColor != Colors.transparent) {
      dotColor = Colors.white;
    }

    if(notInMainCalendar) {
      textColor = Constants.DAY_TEXT_OTHER;
      isShowDot = false;
      boxColor = Colors.transparent;
    }

    var dayStyle =
        TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.bold);
    var lunarDayStyle = TextStyle(fontSize: 10, color: textColor);

    return GestureDetector(
        onTap: () {
          onDayPress(date);
        },
        child: Container(
            padding: EdgeInsets.all(6),
            child: Stack(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        date.day.toString(),
                        style: dayStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        lunarDay.toString(),
                        style: lunarDayStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: boxColor),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Dot(isShowDot, dotColor))
              ],
            ),
            width: width,
            height: width));
  }
}
