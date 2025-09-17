import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:women_diary/schedule/bloc/schedule_bloc.dart';
import 'package:women_diary/schedule/bloc/schedule_event.dart';
import 'package:women_diary/schedule/schedule_model.dart';

class ScheduleCard extends StatefulWidget {
  final ScheduleModel schedule;
  const ScheduleCard({required this.schedule});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late bool _isReminderOn;

  @override
  void initState() {
    super.initState();
    _isReminderOn = widget.schedule.isReminderOn;
  }

  @override
  void didUpdateWidget(covariant ScheduleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync lại khi bloc trả state mới
    if (oldWidget.schedule.isReminderOn != widget.schedule.isReminderOn) {
      _isReminderOn = widget.schedule.isReminderOn;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleTime = DateFormat('HH:mm').format(widget.schedule.time);

    return GestureDetector(
      onTap: () => context
          .navigateTo(RoutesName.scheduleDetail, arguments: widget.schedule)
          .then((_) => context.read<ScheduleBloc>().add(const LoadScheduleEvent())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.shade100.withAlpha(75),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(CupertinoIcons.heart_fill,
                size: 24, color: Colors.pinkAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.schedule.title)
                      .text16()
                      .w600()
                      .customColor(Colors.black87),
                  if (widget.schedule.note.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(widget.schedule.note)
                          .text13()
                          .customColor(Colors.grey.shade600),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.time,
                          size: 14, color: CupertinoColors.systemGrey),
                      const SizedBox(width: 4),
                      Text(scheduleTime)
                          .text13()
                          .customColor(Colors.grey.shade500),
                    ],
                  ),
                ],
              ),
            ),

            /// Switch nhắc nhở
            CupertinoSwitch(
              value: _isReminderOn,
              activeTrackColor: Colors.pinkAccent,
              onChanged: (val) {
                setState(() {
                  _isReminderOn = val; // cập nhật UI ngay
                });
                context
                    .read<ScheduleBloc>()
                    .add(UpdateReminderOnListEvent(widget.schedule));
              },
            ),
          ],
        ),
      ),
    );
  }
}