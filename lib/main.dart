import 'package:flutter/material.dart';
import 'package:reminder/core/localnotification_setup.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/presentation/pages/alarm_setting_page.dart';
import 'package:reminder/presentation/blocs/alarm_bloc.dart';
import 'package:reminder/domain/usecase/Alarm/SetAlarm_usecase.dart';
import 'package:permission_handler/permission_handler.dart';



Future<void> _requestPermissions() async {
  await requestExactAlarmPermission();
}
void main() {
  //initialize notification settings
  _requestPermissions();
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotification().initNotification();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm App',
      home: BlocProvider(
        create: (context) => AlarmBloc(SetAlarmUsecase()),
        child: AlarmSettingPage(),
      ),
    );
  }
}
Future<void> requestExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.request();
  if (status != PermissionStatus.granted) {
    // 설정으로 이동하여 수동으로 권한 허용
    await openAppSettings();
  }
}