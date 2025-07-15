
extension IntExtension on int {
  String convertSecondsToString() {
    String time = '';
    int days = this~/86400;
    int hours = (this - days*86400)~/3600;
    int minutes = (this - days*86400 - hours*3600)~/60;
    int seconds = (this - days*86400 - hours*3600 - minutes*60);

    String hoursString = hours < 10 ? '0$hours' : '$hours';
    String minutesString = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsString = seconds < 10 ? '0$seconds' : '$seconds';

    time = '$hoursString:$minutesString:$secondsString';
    if (days > 0) {
      time = '$days ngày $time';
    }
    return time;
  }
}
