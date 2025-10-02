import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class CycleChart extends StatelessWidget {
  const CycleChart({super.key, required this.cycleList});
  final List<CycleModel> cycleList;

  @override
  Widget build(BuildContext context) {
    return _buildLineChart(cycleList);
  }

  Widget _buildLineChart(List<CycleModel> list) {
    final data = list..sort((a, b) => a.cycleStartTime.compareTo(b.cycleStartTime));

    if (data.isEmpty) return const SizedBox.shrink();

    final minDate = data.first.cycleStartTime;
    final maxDate = data.last.cycleStartTime;

    final spots = <FlSpot>[];
    for (final cycle in data) {
      final days = cycle.cycleEndTime.difference(cycle.cycleStartTime).inDays + 1;
      final x = cycle.cycleStartTime.difference(minDate).inDays.toDouble();
      spots.add(FlSpot(x, days.toDouble()));
    }

    return Container(
      height: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Xu hướng độ dài chu kỳ")
              .w700()
              .text14()
              .customColor(Colors.pink),
          const SizedBox(height: 12),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade400, Colors.pink.shade200],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (v, meta) =>
                          Text("${v.toInt()}d").text10(),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: ((maxDate.difference(minDate).inDays) / 4).clamp(1, 90).toDouble(),
                      getTitlesWidget: (v, meta) {
                        final d = minDate.add(Duration(days: v.toInt()));
                        return Text(DateFormat("MM/yy").format(d)).text10();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => Colors.pink.shade100,
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final date = minDate.add(Duration(days: spot.x.toInt()));
                        return LineTooltipItem(
                          "${DateFormat('dd/MM/yyyy').format(date)}\n${spot.y.toInt()} ngày",
                          const TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
