import 'package:get_it/get_it.dart';
import 'package:reminder/data/repository/example_repository.dart';
import 'package:reminder/domain/repository/example_repository.dart';
import 'package:reminder/data/repository/notification_repository.dart';
import 'package:reminder/domain/repository/notification_repository.dart';
import 'package:reminder/domain/usecase/example/get_example_usecase.dart';
import 'package:reminder/domain/usecase/notification/save_notification_usecase.dart';
import 'package:reminder/domain/usecase/notification/show_notification_usecase.dart';


final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<ExampleRepository>(() => ExampleRepositoryImpl());
  getIt.registerLazySingleton<GetExampleUseCase>(
    () => GetExampleUseCase(repository: getIt<ExampleRepository>()),
  );
  //Dependency Injection save, show usecase
  getIt.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl());
  getIt.registerLazySingleton<ShowNotificationUsecase>(
    () => ShowNotificationUsecase(repository: getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<SaveNotificationUsecase>(
    () => SaveNotificationUsecase(repository: getIt<NotificationRepository>()),
  );
}
