import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/common/widgets/empty_view.dart';
import 'package:women_diary/cycle/bloc/cycle_bloc.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class CycleHistory extends StatelessWidget {
  const CycleHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CycleBloc()..add(const LoadAllCycleEvent()),
      child: const _CycleHistoryView(),
    );
  }
}

class _CycleHistoryView extends StatefulWidget {
  const _CycleHistoryView();

  @override
  State<_CycleHistoryView> createState() => _CycleHistoryViewState();
}

enum _CycleFilter { all, withNotes, last3Months }

class _CycleHistoryViewState extends State<_CycleHistoryView> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  _CycleFilter _filter = _CycleFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BaseAppBar(
        backgroundColor: Colors.pink[200],
        title: 'Lịch sử',
        actions: [
          IconButton(
            tooltip: 'Bộ lọc',
            onPressed: _openFilterSheet,
            icon: Icon(Icons.filter_alt_rounded, color: Colors.white.withAlpha(250)),
          ),
          IconButton(
            onPressed: () {
              context
                  .navigateTo(
                RoutesName.cycleCalendar,
                arguments: context.read<CycleBloc>().cycleList,
              )
                  .then((_) {
                context.read<CycleBloc>().add(const LoadAllCycleEvent());
              });
            },
            icon: Assets.icons.add.svg(
              width: 26,
              height: 26,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CycleBloc, CycleState>(
        buildWhen: (pre, current) => current is LoadedAllCycleState,
        builder: (context, state) {
          if (state is LoadedAllCycleState && state.cycleList.isNotEmpty) {
            final filtered = _applyFilter(state.cycleList);
            return _buildBody(filtered);
          }
          return const EmptyView(
            title: 'Chưa có kỳ kinh nào',
            content: 'Hãy bắt đầu ghi lại để theo dõi chu kỳ của bạn.',
          );
        },
      ),
    );
  }

  // ===== Body với chart + list =====
  Widget _buildBody(List<CycleModel> list) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLineChart(list),
        const SizedBox(height: 20),
        ...list.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCycleItem(list, c),
        )),
      ],
    );
  }

  // ===== Line chart (timeline với cycleStartTime) =====
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
                          Text("${v.toInt()}d", style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: ((maxDate.difference(minDate).inDays) / 4).clamp(1, 90).toDouble(),
                      getTitlesWidget: (v, meta) {
                        final d = minDate.add(Duration(days: v.toInt()));
                        return Text(DateFormat("MM/yy").format(d),
                            style: const TextStyle(fontSize: 10));
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

  // ===== Item cycle =====
  Widget _buildCycleItem(List<CycleModel> list, CycleModel cycle) {
    final maxDays = list
        .map((e) => e.cycleEndTime.difference(e.cycleStartTime).inDays + 1)
        .fold<int>(0, (prev, e) => e > prev ? e : prev);

    final cycleDays = cycle.cycleEndTime.difference(cycle.cycleStartTime).inDays + 1;
    final menstruationDays = cycle.menstruationEndTime.difference(cycle.cycleStartTime).inDays + 1;

    final double totalRatio = (maxDays > 0) ? cycleDays / maxDays : 0;
    final double menstruationRatio = (maxDays > 0) ? menstruationDays / maxDays : 0;

    final now = DateTime.now();
    final bool isCurrent = now.isAfter(cycle.cycleStartTime) &&
        now.isBefore(cycle.cycleEndTime.add(const Duration(days: 1)));

    return Slidable(
      key: ValueKey(cycle.cycleStartTime.millisecondsSinceEpoch),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              context.read<CycleBloc>().add(DeleteCycleEvent(cycle.id));
            },
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Xoá',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          context.navigateTo(RoutesName.cycleDetail, arguments: cycle);
        },
        child: _buildCycleCard(cycle, cycleDays, menstruationDays, totalRatio, menstruationRatio, isCurrent),
      ),
    );
  }

  Widget _buildCycleCard(CycleModel cycle, int cycleDays, int menstruationDays,
      double totalRatio, double menstruationRatio, bool isCurrent) {
    return Container(
      decoration: BoxDecoration(
        gradient: isCurrent
            ? LinearGradient(
          colors: [Colors.pink.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: isCurrent ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent ? Colors.pink.shade300 : Colors.grey.shade200,
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isCurrent ? Colors.pink.shade100 : Colors.black12).withAlpha(30),
            blurRadius: isCurrent ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade400, Colors.red.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Text('🌸').text16(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${dateFormat.format(cycle.cycleStartTime)} - ${dateFormat.format(cycle.cycleEndTime)}',
                ).text13().w700().blackColor().ellipsis().numberOfLines(1),
              ),
              if (isCurrent)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Hiện tại').text12().w700().customColor(Colors.redAccent),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final cycleWidth = totalWidth * totalRatio;
              double mensWidth = totalWidth * menstruationRatio;
              if (mensWidth > cycleWidth) mensWidth = cycleWidth;
              final remainingWidth = (cycleWidth - mensWidth).clamp(0.0, totalWidth);

              return SizedBox(
                height: isCurrent ? 22.0 : 18.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: mensWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              left: const Radius.circular(50),
                              right: Radius.circular(remainingWidth == 0 ? 50 : 0),
                            ),
                            gradient: LinearGradient(
                              colors: isCurrent
                                  ? [Colors.red.shade400, Colors.pink.shade300]
                                  : [Colors.red.shade300, Colors.pink.shade200],
                            ),
                          ),
                        ),
                        Container(
                          width: remainingWidth,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(50),
                            ),
                            gradient: LinearGradient(
                              colors: isCurrent
                                  ? [Colors.pink.shade200, Colors.pink.shade50]
                                  : [Colors.pink.shade100, Colors.pink.shade50],
                            ),
                          ),
                        ),
                      ],
                    ),
                    IgnorePointer(
                      child: Text(
                        '${cycleDays} ngày',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: isCurrent
                              ? Colors.black.withAlpha(200)
                              : Colors.black.withAlpha(150),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _pill('Kinh: ${menstruationDays}d', Colors.red.shade50, Colors.red.shade400),
              const SizedBox(width: 6),
              _pill('Chu kỳ: ${cycleDays}d', Colors.pink.shade50, Colors.pink.shade400),
              if (cycle.note.trim().isNotEmpty) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: _pill(
                    '📝 ${cycle.note.trim()}',
                    Colors.orange.shade50,
                    Colors.orange.shade600,
                    maxLines: 1,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color bg, Color fg, {int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }

  // ===== Filter helpers =====
  List<CycleModel> _applyFilter(List<CycleModel> src) {
    switch (_filter) {
      case _CycleFilter.withNotes:
        return src.where((c) => (c.note.trim().isNotEmpty)).toList();
      case _CycleFilter.last3Months:
        final now = DateTime.now();
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return src.where((c) => c.cycleStartTime.isAfter(threeMonthsAgo)).toList();
      case _CycleFilter.all:
        return src;
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text('Bộ lọc').w700().text14(),
                const SizedBox(height: 12),
                _filterTile(title: 'Tất cả', value: _CycleFilter.all),
                _filterTile(title: 'Có ghi chú', value: _CycleFilter.withNotes),
                _filterTile(title: '3 tháng gần nhất', value: _CycleFilter.last3Months),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterTile({required String title, required _CycleFilter value}) {
    final selected = _filter == value;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? Colors.pink : Colors.grey,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? Colors.pink : Colors.black87,
        ),
      ),
      onTap: () {
        setState(() => _filter = value);
        Navigator.pop(context);
      },
    );
  }
}
