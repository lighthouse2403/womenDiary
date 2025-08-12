import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class MultiRangeCalendar extends StatefulWidget {
  final List<CycleModel> initialRanges;
  final void Function(CycleModel) onAddRange;
  final void Function(String) onDeleteRange; // xóa theo id

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
  late List<CycleModel> _ranges;
  DateTime? _pendingStart;

  @override
  void initState() {
    super.initState();
    _ranges = List.from(widget.initialRanges);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = _generateMonths(DateTime(now.year, now.month - 6), 13);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cycle history"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetRanges,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];
          return _rowInMonth(month);
        },
      ),
    );
  }

  Widget _rowInMonth(DateTime month) {
    final daysInMonth =
    DateUtils.getDaysInMonth(month.year, month.month);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(DateFormat('MMMM yyyy').format(month)).text18().w700(),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: daysInMonth,
          itemBuilder: (context, dayIndex) {
            return _gridCell(dayIndex, month);
          },
        )
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime day, CycleModel range) =>
      !day.isBefore(range.cycleStartTime) && !day.isAfter(range.menstruationEndTime);

  String? _findRangeId(DateTime day) {
    final match = _ranges.firstWhere(
          (r) => _isInRange(day, r),
      orElse: () => CycleModel.init(DateTime(0), DateTime(0)),
    );
    return match.id.isEmpty ? null : match.id;
  }

  void _onDayTapped(DateTime date) {
    setState(() {
      final rangeId = _findRangeId(date);

      if (rangeId != null) {
        // Xóa range đã chọn
        _pendingStart = null;
        widget.onDeleteRange(rangeId);
        _ranges.removeWhere((r) => r.id == rangeId);
        return;
      }

      if (_pendingStart == null) {
        // Chưa có ngày bắt đầu, bắt đầu chọn
        _pendingStart = date;
      } else {
        // Có ngày bắt đầu rồi, tạo range mới
        final start = _pendingStart!;
        DateTime cycleStartTime = start.isBefore(date) ? start : date;
        DateTime cycleEndTime = cycleStartTime.add(Duration(days: 30));
        DateTime menstruationEndTime = start.isAfter(date) ? start : date;
        final newRange = CycleModel.startCycle(
            cycleStartTime,
            cycleEndTime,
            menstruationEndTime
        );
        _ranges.add(newRange);
        _pendingStart = null;
        widget.onAddRange(newRange);
      }
    });
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

  Widget _gridCell(int dayIndex, DateTime month) {
    final day = DateTime(month.year, month.month, dayIndex + 1);
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

    Color dateColor = (isStart || isEnd || isInRange || isPending)
        ? Colors.white
        : Colors.black87;
    return GestureDetector(
      onTap: () => _onDayTapped(day),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isStart || isEnd
              ? Colors.blue
              : isInRange
              ? Colors.blue.withAlpha(70)
              : isPending
              ? Colors.orange.withAlpha(70)
              : null,
          border: isToday
              ? Border.all(color: Colors.red, width: 1.5)
              : Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text('${day.day}').customColor(dateColor),
      ),
    );
  }
}
