import 'package:flutter/material.dart';
import '../../domain/entities/item.dart';
import '../../domain/usecases/get_most_urgent_pending_item_usecase.dart';

class MostUrgentItemWidget extends StatefulWidget {
  final GetMostUrgentPendingItemUsecase usecase;

  const MostUrgentItemWidget({Key? key, required this.usecase}) : super(key: key);

  @override
  _MostUrgentItemWidgetState createState() => _MostUrgentItemWidgetState();
}

class _MostUrgentItemWidgetState extends State<MostUrgentItemWidget> {
  Item? urgentItem;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUrgentItem();
  }

  Future<void> loadUrgentItem() async {
    final item = await widget.usecase.execute(withinDays: 7);
    setState(() {
      urgentItem = item;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (urgentItem == null) {
      return const Center(child: Text("처리할 일이 없습니다."));
    }

    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  urgentItem!.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (urgentItem!.description != null)
                  Text(
                    urgentItem!.description!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  "마감일: ${urgentItem!.due ?? '없음'}",
                  style: const TextStyle(fontSize: 12, color: Colors.redAccent),
                ),
              ],
            ),
          ),
          Icon(Icons.notifications_active, color: Colors.redAccent, size: 30),
        ],
      ),
    );
  }
}