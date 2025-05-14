import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/core/injection_container.dart';
import 'package:reminder/domain/usecase/example/get_example_usecase.dart';
import 'package:reminder/presentation/blocs/example/example_bloc.dart';
import 'package:reminder/presentation/pages/example/view/example_view.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ExampleBloc(getExampleUseCase: getIt<GetExampleUseCase>()),
      child: const ExampleView(),
    );
  }
}
