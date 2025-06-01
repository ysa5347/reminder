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

class _AlarmSettingPageState extends State<AlarmSettingPage> with SingleTickerProviderStateMixin {
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load notifications when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlarmBloc>().add(LoadNotificationsEvent());
    });
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _tabController.dispose();
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
        timeValue: timevalue,
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
      appBar: AppBar(
        title: const Text('알람 설정 & 디버그'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '알람 설정'),
            Tab(text: '디버그'),
          ],
        ),
      ),
      body: BlocListener<AlarmBloc, AlarmState>(
        listener: (context, state) {
          if (state is AlarmSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? '알람이 설정되었습니다')),
            );
          } else if (state is AlarmError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('에러: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAlarmSettingTab(),
            _buildDebugTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmSettingTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _yearController,
                  decoration: const InputDecoration(labelText: '년'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _monthController,
                  decoration: const InputDecoration(labelText: '월'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _dayController,
                  decoration: const InputDecoration(labelText: '일'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hourController,
                  decoration: const InputDecoration(labelText: '시'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _minuteController,
                  decoration: const InputDecoration(labelText: '분'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _setAlarm,
            child: const Text('알람 설정'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showAlarmNow();
            },
            child: const Text('즉시 알람 테스트'),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AlarmBloc>().add(LoadNotificationsEvent());
                  },
                  child: const Text('알람 목록 새로고침'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showClearAllDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('모든 알람 삭제'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '설정된 알람 목록:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<AlarmBloc, AlarmState>(
              builder: (context, state) {
                if (state is AlarmLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationsLoaded) {
                  if (state.notifications.isEmpty) {
                    return const Center(
                      child: Text(
                        '설정된 알람이 없습니다',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = state.notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  );
                } else if (state is AlarmError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AlarmBloc>().add(LoadNotificationsEvent());
                          },
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: Text('알람 목록을 불러오려면 새로고침을 눌러주세요'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(entities.Notification notification) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(
          Icons.notifications_active,
          color: Colors.blue,
        ),
        title: Text(
          notification.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.description != null && notification.description!.isNotEmpty)
              Text(notification.description!),
            const SizedBox(height: 4),
            Text(
              _formatTimeValue(notification.timeValue),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
            Text(
              'ID: ${notification.notificationId}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            _showDeleteDialog(notification.notificationId);
          },
        ),
        isThreeLine: true,
      ),
    );
  }

  String _formatTimeValue(String timeValue) {
    try {
      final parts = timeValue.split('_');
      if (parts.length >= 5) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        final hour = parts[3];
        final minute = parts[4];
        
        return '$year-$month-$day $hour:$minute';
      }
    } catch (e) {
      // ignore
    }
    return timeValue;
  }

  void _showDeleteDialog(int notificationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알람 삭제'),
          content: Text('ID $notificationId 알람을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AlarmBloc>().add(DeleteAlarmByIdEvent(notificationId));
                // Refresh the list after deletion
                Future.delayed(const Duration(milliseconds: 500), () {
                  context.read<AlarmBloc>().add(LoadNotificationsEvent());
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('모든 알람 삭제'),
          content: const Text('모든 설정된 알람을 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AlarmBloc>().add(ClearAllAlarmsEvent());
                // Refresh the list after clearing
                Future.delayed(const Duration(seconds: 2), () {
                  context.read<AlarmBloc>().add(LoadNotificationsEvent());
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('모두 삭제'),
            ),
          ],
        );
      },
    );
  }
}