import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/home_component/app_card.dart';

class QuickStats extends StatelessWidget {
  final CycleData? cycleData;
  QuickStats({
    required this.cycleData
  });

  @override
  Widget build(BuildContext context) {

    String cycleLength = '${cycleData?.cycleLength ?? '_'}';
    String averageCycleLength = '${cycleData?.averageCycleLength ?? '_'}';
    String currentDay = '${cycleData?.currentDay ?? '_'}';
    String ovalutionDay = '${cycleData?.ovalutionDay.globalDateFormat() ?? '_'}';
    String longestLength = '${cycleData?.longestCycle ?? '_'}';
    String shortestLength = '${cycleData?.shortestCycle ?? '_'}';

    final tiles = <Widget>[
      _statCard(title: "📊 Chu kỳ trung bình", value: "$averageCycleLength ngày"),
      _statCard(title: "✨ Độ dài kỳ này", value: "$cycleLength ngày"),
      _statCard(title: "📅 Ngày hiện tại", value: "Ngày $currentDay"),
      _statCard(title: "📅 Ngày rụng trứng", value: "$ovalutionDay"),
      _statCard(title: "⏱ Chu kỳ dài nhất", value: "$longestLength ngày"),
      _statCard(title: "⏳ Chu kỳ ngắn nhất", value: "$shortestLength ngày"),
    ];

    final width = (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: tiles.map((e) => SizedBox(width: width, child: e)).toList(),
    );;
  }

  Widget _statCard({required String title, required String value}) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title).w500().text13(),
          const SizedBox(height: 6),
          Text(value).w700().text16().pinkColor(),
        ],
      ),
    );
  }
}
