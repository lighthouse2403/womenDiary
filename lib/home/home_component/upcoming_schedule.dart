import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/home/home_component/app_card.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:women_diary/schedule/schedule_model.dart';

class UpComingSchedule extends StatelessWidget {
  final ScheduleModel schedule;

  UpComingSchedule({
    required this.schedule
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat("dd/MM/yyyy – HH:mm").format(schedule.time);

    return AppCard(
      color: Colors.orange.shade50,
      border: Border.all(color: Colors.orange.shade200),
      shadows: [
        BoxShadow(
          color: Colors.orange.shade100.withAlpha(100),
          blurRadius: 8,
          offset: const Offset(0, 4),
        )
      ],
      child: Row(
        children: [
          const Icon(Icons.alarm, color: Colors.deepOrange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Lịch hẹn sắp tới").text15().w700(),
                Constants.vSpacer4,
                Text(dateStr).black87Color().text14(),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.navigateTo(RoutesName.scheduleDetail, arguments: schedule);
            },
            child: const Text("Xem"),
          ),
        ],
      ),
    );
  }
}