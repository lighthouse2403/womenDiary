import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MultiRangeCalendar extends StatefulWidget {
  final List<DateTimeRange> initialRanges;
  final void Function(DateTimeRange) onAddRange;
  final void Function(List<DateTimeRange>) onDeleteRange;

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
  late List<DateTimeRange> _ranges;
  DateTime? _pendingStart;
  @override
  void initState() {
    super.initState();
    _ranges = List.from(widget.initialRanges);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime day, DateTimeRange range) =>
      !day.isBefore(range.start) && !day.isAfter(range.end);

  int _findRangeIndex(DateTime day) {
    return _ranges.indexWhere((r) => _isInRange(day, r));
  }

  void _onDayTapped(DateTime date) {
    setState(() {
      final index = _findRangeIndex(date);

      if (index != -1) {
        // Xóa range đã chọn
        _pendingStart = null;
        widget.onDeleteRange([_ranges[index]]);
        _ranges.removeAt(index);

        return;
      }

      if (_pendingStart == null) {
        // Chưa có ngày bắt đầu, bắt đầu chọn
        _pendingStart = date;
      } else {
        // Có ngày bắt đầu rồi, tạo range mới
        final start = _pendingStart!;
        final newRange = DateTimeRange(
          start: start.isBefore(date) ? start : date,
          end: start.isAfter(date) ? start : date,
        );
        _ranges.add(newRange);
        _pendingStart = null;
        widget.onAddRange(newRange);
      }
    });
  }

  void _resetRanges() {
    setState(() {
      widget.onDeleteRange(_ranges);
      _ranges.clear();
      _pendingStart = null;
    });
  }

  List<DateTime> _generateMonths(DateTime from, int count) {
    return List.generate(count, (i) => DateTime(from.year, from.month + i, 1));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = _generateMonths(DateTime(now.year, now.month - 6), 13);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi Range Calendar"),
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
          final daysInMonth =
          DateUtils.getDaysInMonth(month.year, month.month);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  DateFormat('MMMM yyyy').format(month),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
                  final day = DateTime(month.year, month.month, dayIndex + 1);
                  bool isInRange = false;
                  bool isStart = false;
                  bool isEnd = false;

                  for (final r in _ranges) {
                    if (_isInRange(day, r)) {
                      isInRange = true;
                      if (_isSameDay(day, r.start)) isStart = true;
                      if (_isSameDay(day, r.end)) isEnd = true;
                      break;
                    }
                  }

                  final isToday = _isSameDay(day, DateTime.now());
                  final isPending = _pendingStart != null &&
                      _isSameDay(_pendingStart!, day);

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
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: (isStart || isEnd || isInRange || isPending)
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
