import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Show custom feminine DateTime picker
Future<DateTime?> showFeminineDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  DateTime? pickedDate;
  TimeOfDay? pickedTime;

  // Step 1: Pick Date
  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Date Picker",
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, __, ___) {
      final scale = Curves.easeOutBack.transform(animation.value);
      return Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: animation.value,
          child: _FeminineDatePickerDialog(
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            onDateSelected: (d) {
              pickedDate = d;
              Navigator.pop(context);
            },
          ),
        ),
      );
    },
  );

  if (pickedDate == null) return null;

  // Step 2: Pick Time
  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Time Picker",
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, __, ___) {
      final scale = Curves.easeOutBack.transform(animation.value);
      return Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: animation.value,
          child: _FeminineTimePickerDialog(
            initialTime: TimeOfDay.fromDateTime(initialDate),
            onTimeSelected: (t) {
              pickedTime = t;
              Navigator.pop(context);
            },
          ),
        ),
      );
    },
  );

  if (pickedTime == null) return null;

  // Combine date + time
  return DateTime(
    pickedDate!.year,
    pickedDate!.month,
    pickedDate!.day,
    pickedTime!.hour,
    pickedTime!.minute,
  );
}

/// -------------------- Date Picker Dialog --------------------
class _FeminineDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateSelected;

  const _FeminineDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  State<_FeminineDatePickerDialog> createState() =>
      _FeminineDatePickerDialogState();
}

class _FeminineDatePickerDialogState
    extends State<_FeminineDatePickerDialog> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.purple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat.yMMMM().format(selectedDate),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Theme(
              data: Theme.of(context).copyWith(
                datePickerTheme: DatePickerThemeData(
                  backgroundColor: Colors.transparent,
                  dayBackgroundColor:
                  WidgetStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.pink.shade400; // ngày được chọn
                    }
                    if (states.contains(WidgetState.focused)) {
                      return Colors.pink.shade100;
                    }
                    return null;
                  }),
                  dayForegroundColor:
                  WidgetStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white; // chữ khi chọn
                    }
                    return Colors.black87;
                  }),
                  todayBackgroundColor:
                  WidgetStateProperty.all(Colors.pink.shade100), // hôm nay
                  todayForegroundColor:
                  WidgetStateProperty.all(Colors.pink.shade800),
                  dayShape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  dayStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: CalendarDatePicker(
                initialDate: widget.initialDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                currentDate: DateTime.now(),
                onDateChanged: (d) {
                  setState(() => selectedDate = d);
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => widget.onDateSelected(selectedDate),
              icon: const Icon(Icons.favorite, color: Colors.white),
              label: const Text(
                "Chọn ngày này 💕",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// -------------------- Time Picker Dialog --------------------
class _FeminineTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const _FeminineTimePickerDialog({
    required this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<_FeminineTimePickerDialog> createState() =>
      _FeminineTimePickerDialogState();
}

class _FeminineTimePickerDialogState extends State<_FeminineTimePickerDialog> {
  late DateTime tempDateTime;

  @override
  void initState() {
    super.initState();
    tempDateTime = DateTime(
      0,
      1,
      1,
      widget.initialTime.hour,
      widget.initialTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.purple.shade50],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Chọn giờ 🌸",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade700,
                )),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: tempDateTime,
                use24hFormat: true,
                onDateTimeChanged: (dt) => tempDateTime = dt,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => widget.onTimeSelected(
                TimeOfDay.fromDateTime(tempDateTime),
              ),
              icon: const Icon(Icons.access_time, color: Colors.white),
              label: const Text("Chọn giờ này 💕",
                  style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
