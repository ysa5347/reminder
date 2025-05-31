import 'package:get_it/get_it.dart';
import 'package:reminder/data/repository/example_repository.dart';
import 'package:reminder/domain/repository/example_repository.dart';
import 'package:reminder/domain/repository/item_repository.dart';
import 'package:reminder/data/repository/item_repository_impl.dart';
import 'package:reminder/data/repository/notification_repository_impl.dart';
import 'package:reminder/domain/repository/notification_repository.dart';

import 'package:reminder/domain/usecase/example/get_example_usecase.dart';
import 'package:reminder/domain/usecase/notification/GetNotifications_usecase.dart';
import 'package:reminder/domain/usecase/item/GetItems_usecase.dart';
import 'package:reminder/domain/usecase/item/SaveItem_usecase.dart';
//import 'package:reminder/domain/usecase/Alarm/SetAlarm_usecase.dart';
//import 'package:reminder/domain/usecase/Alarm/DeleteAlarm_usecase.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<ExampleRepository>(() => ExampleRepositoryImpl());
  getIt.registerLazySingleton<GetExampleUseCase>(
    () => GetExampleUseCase(repository: getIt<ExampleRepository>()),
  );
  //Dependency Injection save, show usecase
  getIt.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl());
  getIt.registerLazySingleton<ItemRepository>(() => ItemRepositoryImpl());

  getIt.registerLazySingleton<GetItemsUsecase>(
    () => GetItemsUsecase(repository: getIt<ItemRepository>()),
  );
  getIt.registerLazySingleton<SaveItemUsecase>(
    () => SaveItemUsecase(repository: getIt<ItemRepository>()),
  );
  getIt.registerLazySingleton<GetNotificationsUsecase>(
    () => GetNotificationsUsecase(repository: getIt<NotificationRepository>()),
  );
  /*
  getIt.registerLazySingleton<AlarmRepository>(() => AlarmRepositoryImpl());
  getIt.registerLazySingleton<SetAlarmUsecase>(
    () => SetAlarmUsecase(repository: getIt<AlarmRepository>()),
  );
  getIt.registerLazySingleton<DeleteAlarmUsecase>(
    () => DeleteAlarmUsecase(repository: getIt<AlarmRepository>()
    )
  );
  */
}
