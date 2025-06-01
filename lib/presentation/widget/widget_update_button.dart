import 'package:flutter/material.dart';
import 'package:reminder/domain/usecases/get_most_urgent_pending_item_usecase.dart';
import 'package:reminder/presentation/widgets/widget_updater.dart';

class WidgetUpdateButton extends StatelessWidget {
  final GetMostUrgentPendingItemUsecase usecase;

  const WidgetUpdateButton({super.key, required this.usecase});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final item = await usecase.execute(); // 가장 급한 할 일 가져오기
        final text = item?.title ?? '처리할 일이 없습니다';
        await updateUrgentTaskWidget(text);  // 위젯 데이터 저장 및 새로고침

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('홈 위젯이 업데이트되었습니다')),
        );
      },
      child: Text("홈 위젯 수동 업데이트"),
    );
  }
}
