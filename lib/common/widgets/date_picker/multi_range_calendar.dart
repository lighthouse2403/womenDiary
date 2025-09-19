import 'package:flutter/material.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MultiRangeCalendar extends StatefulWidget {
  final List<CycleModel> initialRanges;
  final void Function(CycleModel) onAddRange;
  final void Function(String) onDeleteRange;
  final DateTime? minDate;
  final DateTime? maxDate;

  const MultiRangeCalendar({
    super.key,
    this.initialRanges = const [],
    required this.onAddRange,
    required this.onDeleteRange,
    this.minDate,
    this.maxDate,
  });

  @override
  State<MultiRangeCalendar> createState() => _MultiRangeCalendarState();
}

class _MultiRangeCalendarState extends State<MultiRangeCalendar> {
  DateTime? _pendingStart;
  late List<CycleModel> _ranges;
  late List<DateTime> _months;

  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener =
  ItemPositionsListener.create();

  int? _todayIndex;
  bool _showTodayButton = false;

  @override
  void initState() {
    super.initState();
    _ranges = List.from(widget.initialRanges);

    final min = widget.minDate ?? DateTime.now().subtract(const Duration(days: 730));
    final max = widget.maxDate ?? DateTime.now().add(const Duration(days: 365));
    _months = _generateMonths(min, max);

    final now = DateTime.now();
    _todayIndex =
        _months.indexWhere((m) => m.year == now.year && m.month == now.month);

    // Scroll đến tháng hiện tại
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_todayIndex != null && _todayIndex != -1 && _scrollController.isAttached) {
        _scrollController.scrollTo(
          index: _todayIndex!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    // Theo dõi vị trí scroll để hiển thị nút hôm nay
    _positionsListener.itemPositions.addListener(() {
      if (_todayIndex == null) return;
      final positions = _positionsListener.itemPositions.value;
      if (positions.isEmpty) return;

      final visibleIndexes = positions.map((e) => e.index).toList();
      final isTodayVisible = visibleIndexes.contains(_todayIndex);

      if (_showTodayButton == isTodayVisible) {
        setState(() {
          _showTodayButton = !isTodayVisible;
        });
      }
    });
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
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: BaseAppBar(
        backgroundColor: Colors.pink[200],
        title: "Chu kỳ",
        hasBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetRanges,
          )
        ],
      ),
      body: ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemPositionsListener: _positionsListener,
        itemCount: _months.length,
        itemBuilder: (context, index) => _buildMonthView(_months[index]),
      ),
      floatingActionButton: (_showTodayButton && _todayIndex != null)
          ? FloatingActionButton(
        backgroundColor: Colors.pink[300],
        child: const Icon(Icons.today, color: Colors.white),
        onPressed: () {
          if (_todayIndex != null && _scrollController.isAttached) {
            _scrollController.scrollTo(
              index: _todayIndex!,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
      )
          : null,
    );
  }

  Widget _buildMonthView(DateTime month) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final firstWeekday = DateTime(month.year, month.month, 1).weekday;
    final dayHeaders = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];

    final totalCells = daysInMonth + (firstWeekday - 1);
    final cells = List<DateTime?>.generate(totalCells, (index) {
      final dayNum = index - (firstWeekday - 2);
      if (dayNum > 0 && dayNum <= daysInMonth) {
        return DateTime(month.year, month.month, dayNum);
      }
      return null;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề tháng
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

        // Hàng tiêu đề thứ
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: List.generate(7, (index) {
              return Expanded(
                child: Center(
                  child: Text(
                    dayHeaders[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Lưới ngày
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: cells.length,
          itemBuilder: (context, index) {
            final day = cells[index];
            if (day == null) return const SizedBox.shrink();
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

    final isBeforeMin = widget.minDate != null && day.isBefore(widget.minDate!);
    final isAfterMax = widget.maxDate != null && day.isAfter(widget.maxDate!);
    final isDisabled = isBeforeMin || isAfterMax;

    Color? bgColor;
    Color textColor = isDisabled ? Colors.grey : Colors.black87;

    if (!isDisabled) {
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
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: isDisabled ? null : () => _onDayTapped(day),
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
      !day.isBefore(range.cycleStartTime) && !day.isAfter(range.menstruationEndTime);

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

  /// Tạo list tháng từ min -> max
  List<DateTime> _generateMonths(DateTime min, DateTime max) {
    final months = <DateTime>[];
    DateTime cursor = DateTime(min.year, min.month);
    final end = DateTime(max.year, max.month);

    while (!cursor.isAfter(end)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    return months;
  }
}
