import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/home/app_card.dart';

class QuickStats extends StatelessWidget {
  final int currentDay;
  final int cycleLength;
  final int daysUntilNext;
  QuickStats({
    required this.currentDay,
    required this.cycleLength,
    required this.daysUntilNext
  });

  @override
  Widget build(BuildContext context) {
    final expectedEnd =
    DateTime.now().add(Duration(days: daysUntilNext));
    final endStr = DateFormat('dd/MM/yyyy').format(expectedEnd);

    final tiles = <Widget>[
      _statCard(title: "📊 Trung bình chu kỳ", value: "$cycleLength ngày"),
      _statCard(title: "📅 Ngày hiện tại", value: "Ngày $currentDay"),
      _statCard(title: "🔮 Dự kiến kết thúc", value: endStr),
      _statCard(title: "⏱ Chu kỳ ngắn nhất", value: "—"),
      _statCard(title: "⏳ Chu kỳ dài nhất", value: "—"),
      _statCard(title: "✨ Dự kiến độ dài kỳ này", value: "$cycleLength ngày"),
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