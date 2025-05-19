class ReminderWidget extends StatelessWidget {
  const ReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderBloc, ReminderState>(
      builder: (context, state) {
        if (state is ReminderLoading) {
          return const CircularProgressIndicator();
        } else if (state is ReminderLoaded) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.access_alarm),
              title: Text(state.reminder.title),
              subtitle: Text(state.reminder.dueDate.toString()),
            ),
          );
        } else {
          return const Text("가장 빠른 리마인더가 없습니다.");
        }
      },
    );
  }
}
