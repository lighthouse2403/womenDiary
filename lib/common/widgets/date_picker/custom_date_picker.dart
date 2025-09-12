import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

Future<DateTime?> showFeminineDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  Locale? locale,
}) async {
  DateTime selectedDate = initialDate;
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(initialDate);

  return await showGeneralDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "DateTime Picker",
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, __, ___) {
      final scale = Curves.easeOutBack.transform(animation.value);
      return Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: animation.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
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
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Chọn ngày & giờ 🌸",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Calendar
                      TableCalendar(
                        locale: locale?.languageCode ?? 'vi',
                        focusedDay: selectedDate,
                        firstDay: firstDate,
                        lastDay: lastDate,
                        currentDay: DateTime.now(),
                        selectedDayPredicate: (day) =>
                            isSameDay(day, selectedDate),
                        onDaySelected: (day, _) {
                          setState(() => selectedDate = day);
                        },
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.pink.shade400,
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: TextStyle(
                            color: Colors.pink.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                          selectedTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            color: Colors.pink.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Time Picker
                      SizedBox(
                        height: 150,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          ),
                          use24hFormat: true,
                          onDateTimeChanged: (dt) {
                            setState(() {
                              selectedTime = TimeOfDay.fromDateTime(dt);
                            });
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
                        onPressed: () {
                          Navigator.pop(
                            context,
                            DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            ),
                          );
                        },
                        icon: const Icon(Icons.favorite, color: Colors.white),
                        label: const Text(
                          "Xác nhận 💕",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}
