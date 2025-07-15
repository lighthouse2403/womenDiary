
import 'package:flutter/material.dart';
import 'package:baby_diary/calendar/components/calendar/calendar.dart';
import 'package:baby_diary/calendar/components/event/event_list.dart';
import 'package:baby_diary/calendar/model/event_VO.dart';
import 'package:baby_diary/calendar/services/data_service.dart';

class MonthContainer extends StatefulWidget {
  const MonthContainer({super.key});

  @override
  State createState() {
    return _MonthContainerState();
  }
}

class _MonthContainerState extends State<MonthContainer>
    with AutomaticKeepAliveClientMixin<MonthContainer> {
  List<EventVO> _eventData = [];
  List<EventVO> _eventByMonths = [];
  List<DateTime> _markedDates = [];
  DateTime _calendar = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var data = await loadEventData();
    setState(() {
      _eventData = data;
    });
    _generateEventByMonth(_calendar.month);
    _generateMarkedDates();
  }

  void _generateMarkedDates() {
    _markedDates.clear();
    for (var event in _eventData) {
      _markedDates.add(event.date);
    }
  }

  void _generateEventByMonth(int month) {
    _eventByMonths.clear();
    for (var event in _eventData) {
      if (event.date.month == month) {
        _eventByMonths.add(event);
      }
    }
    setState(() {
      _eventByMonths = _eventByMonths;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pregnancy_backgroound_3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 60),
          child: Column(
            children: <Widget>[
              Calendar(
                markedDays: _markedDates,
                onDateTimeChanged: (newDate) {
                  setState(() {
                    _calendar = newDate;
                  });
                  _generateEventByMonth(newDate.month);
                },
              ),
              Expanded(
                  flex: 1,
                  child: EventList(
                    data: _eventByMonths,
                  ))
            ],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
