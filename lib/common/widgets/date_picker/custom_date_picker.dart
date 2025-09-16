import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:women_diary/common/extension/text_extension.dart';

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
              borderRadius: BorderRadius.circular(28),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade50, Colors.purple.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade100.withAlpha(80),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Chọn ngày & giờ 🌸"
                      ).w600().text24().customColor(Colors.purple.shade700),
                      const SizedBox(height: 12),
                      // Calendar
                      TableCalendar(
                        locale: locale?.languageCode ?? 'vi',
                        focusedDay: selectedDate,
                        firstDay: firstDate,
                        lastDay: lastDate,
                        currentDay: DateTime.now(),
                        selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                        onDaySelected: (day, _) {
                          setState(() => selectedDate = day);
                        },

                        // 👇 Thêm 2 dòng này để fix chiều cao
                        calendarFormat: CalendarFormat.month,
                        sixWeekMonthsEnforced: true,

                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.pink.shade200, Colors.purple.shade200],
                            ),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.pink.shade400, Colors.purple.shade300],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.shade100,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          todayTextStyle: const TextStyle(
                            color: Colors.white,
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
                          leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.pink.shade400),
                          rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.pink.shade400),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Time Picker
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(180),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.shade100,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
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
                      const SizedBox(height: 20),
                      // Confirm button
                      InkWell(
                        onTap: () {
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
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.pink.shade400, Colors.purple.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.shade200.withAlpha(130),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.favorite, color: Colors.white),
                              const SizedBox(width: 8),
                              Text("Xác nhận 💕")
                                  .w600()
                                  .whiteColor()
                                  .text16(),
                            ],
                          ),
                        ),
                      )
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
