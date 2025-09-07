import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    final tiles = <Widget>[
      _statCard(title: "📊 Chu kỳ trung bình", value: "$cycleLength ngày"),
      _statCard(title: "📅 Ngày hiện tại", value: "Ngày ${cycleData?.currentDay ?? '_'}"),
      _statCard(title: "⏱ Chu kỳ ngắn nhất", value: "—"),
      _statCard(title: "⏳ Chu kỳ dài nhất", value: "—"),
      _statCard(title: "✨ Dự kiến độ dài kỳ này", value: "${cycleData.cycleLength} ngày"),
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
