import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/alarm/alarm_bloc.dart';
import '../../blocs/alarm/alarm_event.dart';
import '../../blocs/alarm/alarm_state.dart';
import 'package:reminder/domain/entities/notification_entities.dart' as entities;

import 'package:reminder/core/localnotification_setup.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmSettingPage extends StatefulWidget {
  @override
  _AlarmSettingPageState createState() => _AlarmSettingPageState();
}

class _AlarmSettingPageState extends State<AlarmSettingPage> {
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _setAlarm() {
    final year = int.tryParse(_yearController.text);
    final month = int.tryParse(_monthController.text);
    final day = int.tryParse(_dayController.text);
    final hour = int.tryParse(_hourController.text);
    final minute = int.tryParse(_minuteController.text);

    if (year != null && month != null && day != null && hour != null && minute != null) {
      final timevalue = '${year}_${month.toString().padLeft(2, '0')}_${day.toString().padLeft(2, '0')}_${hour.toString().padLeft(2, '0')}_${minute.toString().padLeft(2, '0')}';
      
      final notification = entities.Notification(
        notificationId: 1, // 임시 ID 생성
        timevalue: timevalue,
        title: '알람',
        description: '설정된 알람입니다',
      );
      
      context.read<AlarmBloc>().add(SetAlarmEvent(notification));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 올바르게 입력해주세요')),
      );
    }
  }
  NotificationDetails notificationDetails() {
        return const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel_id',
            'Daily Notificatioin',
            channelDescription: 'This channel is used for daily notifications',
            importance: Importance.max,
            priority: Priority.high,

            playSound: true,
            enableVibration: true,
            fullScreenIntent: true,  // 잠금화면에서도 표시
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
          ),
        );
      }
  Future<void> showAlarmNow() async {
  await FlutterLocalNotification().notificationsPlugin.show(
    0,  // 알림 ID
    '알람',
    '설정한 시간입니다!',
    notificationDetails(),
    payload: 'alarm_payload',
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('알람 설정')),
      body: BlocListener<AlarmBloc, AlarmState>(
        listener: (context, state) {
          if (state is AlarmSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('알람이 설정되었습니다')),
            );
          } else if (state is AlarmError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('에러: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _yearController,
                      decoration: InputDecoration(labelText: '년'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _monthController,
                      decoration: InputDecoration(labelText: '월'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _dayController,
                      decoration: InputDecoration(labelText: '일'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hourController,
                      decoration: InputDecoration(labelText: '시'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _minuteController,
                      decoration: InputDecoration(labelText: '분'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _setAlarm,
                child: Text('알람 설정'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  showAlarmNow(
                  );
                },
                child: const Text('direct alarm')
              ),
            ],
          ),
        ),
      ),
    );
  }
}