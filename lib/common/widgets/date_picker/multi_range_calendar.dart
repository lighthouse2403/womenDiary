import 'package:flutter/material.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/font_size_extension.dart';
import 'package:women_diary/common/extension/font_weight_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class MultiRangeCalendar extends StatefulWidget {
  final List<CycleModel> initialRanges;
  final void Function(CycleModel) onAddRange;
  final void Function(String) onDeleteRange;

  const MultiRangeCalendar({
    super.key,
    this.initialRanges = const [],
    required this.onAddRange,
    required this.onDeleteRange,
  });

  @override
  State<MultiRangeCalendar> createState() => _MultiRangeCalendarState();
}

class _MultiRangeCalendarState extends State<MultiRangeCalendar> {
  DateTime? _pendingStart;
  late List<CycleModel> _ranges;

  @override
  void initState() {
    super.initState();
    _ranges = List.from(widget.initialRanges);
  }

  @override
  void didUpdateWidget(covariant MultiRangeCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRanges != widget.initialRanges) {
      _ranges = List.from(widget.initialRanges);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = _generateMonths(DateTime(now.year, now.month - 6, 1), 13);

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: BaseAppBar(
        backgroundColor: Colors.pink[200],
        title: "Nhật ký chu kỳ",
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetRanges,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: months.length,
        itemBuilder: (context, index) => _buildMonthView(months[index]),
      ),
    );
  }

  Widget _buildMonthView(DateTime month) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.pink[100],
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.shade100.withAlpha(80),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(month.globalMonthFormat('vi')).text18().w700().pinkColor(),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: daysInMonth,
          itemBuilder: (context, dayIndex) {
            final day = DateTime(month.year, month.month, dayIndex + 1);
            return _buildDayCell(day);
          },
        ),
      ],
    );
  }

  Widget _buildDayCell(DateTime day) {
    bool isInRange = false;
    bool isStart = false;
    bool isEnd = false;

    for (final r in _ranges) {
      if (_isInRange(day, r)) {
        isInRange = true;
        if (_isSameDay(day, r.cycleStartTime)) isStart = true;
        if (_isSameDay(day, r.menstruationEndTime)) isEnd = true;
        break;
      }
    }

    final isToday = _isSameDay(day, DateTime.now());
    final isPending = _pendingStart != null && _isSameDay(_pendingStart!, day);

    Color? bgColor;
    Color textColor = Colors.black87;

    if (isStart) {
      bgColor = Colors.pink[400];
      textColor = Colors.white;
    } else if (isEnd) {
      bgColor = Colors.pink[300];
      textColor = Colors.white;
    } else if (isInRange) {
      bgColor = Colors.pink[100];
      textColor = Colors.white;
    } else if (isPending) {
      bgColor = Colors.orange[200];
      textColor = Colors.white;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => _onDayTapped(day),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(100),
            border: isToday
                ? Border.all(color: Colors.redAccent, width: 2)
                : Border.all(color: Colors.transparent),
          ),
          child: Text(
            '${day.day}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime day, CycleModel range) =>
      !day.isBefore(range.cycleStartTime) &&
          !day.isAfter(range.menstruationEndTime);

  String? _findRangeId(DateTime day) {
    for (final r in _ranges) {
      if (_isInRange(day, r)) return r.id;
    }
    return null;
  }

  void _onDayTapped(DateTime date) {
    final rangeId = _findRangeId(date);

    if (rangeId != null) {
      setState(() {
        _pendingStart = null;
        _ranges.removeWhere((r) => r.id == rangeId);
      });
      widget.onDeleteRange(rangeId);
      return;
    }

    if (_pendingStart == null) {
      setState(() {
        _pendingStart = DateTime(date.year, date.month, date.day);
      });
    } else {
      final start = _pendingStart!;
      final firstDay =
      start.isBefore(date) ? start : DateTime(date.year, date.month, date.day);
      final lastDay =
      start.isAfter(date) ? start : DateTime(date.year, date.month, date.day);

      final newRange = CycleModel.startCycle(
        firstDay,
        firstDay.add(const Duration(days: 30)),
        lastDay,
      );

      setState(() {
        _pendingStart = null;
        _ranges.add(newRange);
      });

      widget.onAddRange(newRange);
    }
  }

  void _resetRanges() {
    setState(() {
      for (var r in _ranges) {
        widget.onDeleteRange(r.id);
      }
      _ranges.clear();
      _pendingStart = null;
    });
  }

  List<DateTime> _generateMonths(DateTime from, int count) {
    return List.generate(count, (i) => DateTime(from.year, from.month + i, 1));
  }
}
