import 'package:flutter/material.dart';
import 'package:baby_diary/calendar/model/event_VO.dart';
import 'package:baby_diary/calendar/utils/date_utils.dart';
import 'package:baby_diary/calendar/utils/lunar_solar_utils.dart';

class EventItem extends StatelessWidget {
  const EventItem({super.key, required this.event});
  final EventVO event;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    const titleStyle = TextStyle(color: Colors.white);
    const contentStyle = TextStyle(color: Colors.white);
    var dayOfWeek = getNameDayOfWeek(event.date);
    var lunarDates = convertSolar2Lunar(event.date.year, event.date.month, event.date.day, 7);
    var lunarDay = lunarDates[0];
    var lunarMonth = lunarDates[1];
    var title = '* ${dayOfWeek} - ${event.date.day}/${event.date.day} (${lunarDay}/${lunarMonth} AL)';
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                ),
            child: Text(title, style: titleStyle),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: Text(event.event, style: contentStyle),
          )
        ],
      ),
    );
  }
}
