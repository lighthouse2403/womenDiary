int getMonthFirstDayOffset(int year, int month, int firstDayOfWeekIndex) {
  final int weekdayFromMonday = DateTime(year, month).weekday - 1;
  firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;
  return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
}
