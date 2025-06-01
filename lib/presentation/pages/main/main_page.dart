import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/main/main_bloc.dart';
import '../../blocs/main/main_event.dart';
import 'view/main_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc()..add(LoadMainData()),
      child: const MainView(),
    );
  }
}
