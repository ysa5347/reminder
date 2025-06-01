import 'package:home_widget/home_widget.dart';

Future<void> updateHomeWidget(String title, String dueDate) async {
  await HomeWidget.saveWidgetData<String>('title', title);
  await HomeWidget.saveWidgetData<String>('dueDate', dueDate);
  await HomeWidget.updateWidget(name: 'HomeWidgetProvider');  // 위젯 Provider 이름 확인 필요
}
