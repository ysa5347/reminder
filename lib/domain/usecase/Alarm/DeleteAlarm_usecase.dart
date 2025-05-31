import 'package:reminder/core/localnotification_setup.dart';

class DeleteAlarmUsecase {

  Future<void> execute(int notificationId) async {
    await FlutterLocalNotification().notificationsPlugin.cancel(notificationId);
  }
}