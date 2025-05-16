class Notification{
  final int notificationId;
  final String text;
  final String timeValue; //format: date_hour_minute
  final String? period;

  Notification(
      this.period, 
      {
        required this.notificationId, 
        required this.text, 
        required this.timeValue
      }
    );
}
