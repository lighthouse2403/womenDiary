import 'package:flutter/material.dart';
import 'package:baby_diary/calendar/model/event_VO.dart';
import 'event_item.dart';

class EventList extends StatelessWidget {
  const EventList({required this.data});
  final List<EventVO> data;

  Widget renderItem(EventVO event) {
    return EventItem(event: event);
  }

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int index) {
        return renderItem(data[index]);
      },
    );
  }
}