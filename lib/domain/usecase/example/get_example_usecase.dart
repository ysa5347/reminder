import 'package:reminder/domain/entities/example.dart';
import 'package:reminder/domain/repository/example_repository.dart';

class GetSoonestReminderUseCase {
  final ReminderRepository repository;

  GetSoonestReminderUseCase(this.repository);

  Future<Reminder?> call() async {
    final reminders = await repository.getAllReminders();
    if (reminders.isEmpty) return null;

    reminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return reminders.first;
  }
}
//가장 빠르게 마감일 설정되어있는 Reminder항목을 찾아 반환하려고 만들었습니다.