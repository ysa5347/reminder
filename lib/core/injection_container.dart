import 'package:get_it/get_it.dart';
import 'package:reminder/data/repository/example_repository.dart';
import 'package:reminder/domain/repository/example_repository.dart';
import 'package:reminder/domain/usecase/example/get_example_usecase.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<ExampleRepository>(() => ExampleRepositoryImpl());
  getIt.registerLazySingleton<GetExampleUseCase>(
    () => GetExampleUseCase(repository: getIt<ExampleRepository>()),
  );
}
