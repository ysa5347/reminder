import 'package:flutter/material.dart' as material;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder/domain/repository/notification_repository.dart';
import 'package:reminder/domain/entities/notification_entities.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  @override
  Future<Notification> saveNotification(String timeValue, String title) async {
    //notificationId생성, 고유해야함
    String period = timeValue.substring(0, timeValue.length - 13);
    return Notification(
      period,
      notificationId: DateTime.now().millisecondsSinceEpoch, //고유 id로 변환
      timeValue: timeValue,
      text: title, // Default text since notification object is not defined
    );
  }

  @override
  Future<List<Notification>> showNotification(String date) async {
    // TODO: get Notification value when date
    /*
    period = 
    text = 
    timeValue = 
    return Notification(period, text: text, timeValue: timeValue);
    */
    throw UnimplementedError();
    
  }
  
  @override
  Future<Notification> deleteNotification(int notificationId) {
    // TODO: delete notiication data by using notificationId
    throw UnimplementedError();
  }
}