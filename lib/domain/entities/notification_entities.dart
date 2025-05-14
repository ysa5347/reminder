class Notification{
  final String text;
  final String timeDate;
  final String? timeHour;
  final String? timeMinute;
  final String? timeSecond;

  Notification(this.timeHour, this.timeMinute, this.timeSecond, {required this.text, required this.timeDate});
}