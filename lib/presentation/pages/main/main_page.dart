import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/main/main_bloc.dart';
import '../../blocs/main/main_event.dart';
import '../../blocs/category/category_bloc.dart';
import 'view/main_view.dart';
import '../../../core/injection_container.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(
          create: (context) => getIt<MainBloc>()..add(LoadMainData()),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => getIt<CategoryBloc>(),
        ),
      ],
      child: const MainView(),
    );
  }
}
