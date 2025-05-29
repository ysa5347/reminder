import 'package:reminder/domain/repository/notification_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder/core/localnotification_setup.dart';

class DeleteAlarmUsecase{
  final AlarmRepository repository;

  DeleteAlarmUsecase({required this.repository});

  Future<void> execute(int notificationId) async{
    await FlutterLocalNotification().notificationsPlugin.cancel(notificationId);

    return await repository.deleteAlarmByNotificationId(notificationId);
  }
}