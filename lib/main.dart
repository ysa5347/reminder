import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Core imports
import 'package:reminder/core/injection_container.dart' as di;
import 'package:reminder/core/localnotification_setup.dart';

// Presentation imports
import 'package:reminder/presentation/pages/alarm/alarm_setting_page.dart';
import 'package:reminder/presentation/blocs/alarm/alarm_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Request permissions first
  await _requestPermissions();
  
  // 2. Initialize dependency injection container
  await di.setupLocator();
  
  // 3. Initialize notifications
  await FlutterLocalNotification().initNotification();
  
  // 4. Initialize timezone
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => di.getIt<AlarmBloc>(),
        child: AlarmSettingPage(),
      ),
    );
  }
}

Future<void> _requestPermissions() async {
  try {
    final status = await Permission.scheduleExactAlarm.request();
    if (status != PermissionStatus.granted) {
      // 설정으로 이동하여 수동으로 권한 허용
      await openAppSettings();
    }
  } catch (e) {
    debugPrint('Permission request failed: $e');
  }
}