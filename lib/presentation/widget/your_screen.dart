import 'package:flutter/material.dart';
import 'package:reminder/domain/usecases/get_most_urgent_pending_item_usecase.dart';
import 'package:reminder/presentation/widgets/widget_update_button.dart';

class HomeScreen extends StatelessWidget {
  final GetMostUrgentPendingItemUsecase usecase;

  const HomeScreen({super.key, required this.usecase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("홈")),
      body: Center(
        child: WidgetUpdateButton(usecase: usecase),  // 여기서 사용!
      ),
    );
  }
}
