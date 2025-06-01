import 'package:get_it/get_it.dart';

// Database & DAOs
import 'package:reminder/data/datasource/local.dart';
import 'package:reminder/data/dao/item_dao.dart';
import 'package:reminder/data/dao/category_dao.dart';
import 'package:reminder/data/dao/notification_dao.dart';
import 'package:reminder/data/dao/repeat_dao.dart';

// Repositories
import 'package:reminder/data/repository/example_repository.dart';
import 'package:reminder/domain/repository/example_repository.dart';
import 'package:reminder/data/repository/item_repository_impl.dart';
import 'package:reminder/domain/repository/item_repository.dart';
import 'package:reminder/data/repository/category_repository_impl.dart';
import 'package:reminder/domain/repository/category_repository.dart';
import 'package:reminder/data/repository/notification_repository_impl.dart';
import 'package:reminder/domain/repository/notification_repository.dart';
import 'package:reminder/data/repository/repeat_repository_impl.dart';
import 'package:reminder/domain/repository/repeat_repository.dart';

// Use Cases
import 'package:reminder/domain/usecase/example/get_example_usecase.dart';
import 'package:reminder/domain/usecase/notification/GetNotifications_usecase.dart';
import 'package:reminder/domain/usecase/item/GetItems_usecase.dart';
import 'package:reminder/domain/usecase/item/SaveItem_usecase.dart';
import 'package:reminder/domain/usecase/item/get_all_items_usecase.dart';
import 'package:reminder/domain/usecase/Alarm/SetAlarm_usecase.dart';
import 'package:reminder/domain/usecase/Alarm/DeleteAlarm_usecase.dart';

// BLoCs
import 'package:reminder/presentation/blocs/example/example_bloc.dart';
import 'package:reminder/presentation/blocs/alarm/alarm_bloc.dart';

// Core Services
import 'package:reminder/core/localnotification_setup.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // ========== External Dependencies ==========
  
  // Database
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  getIt.registerSingleton<AppDatabase>(database);
  
  // DAOs
  getIt.registerLazySingleton<ItemDao>(() => getIt<AppDatabase>().itemDao);
  getIt.registerLazySingleton<CategoryDao>(() => getIt<AppDatabase>().categoryDao);
  getIt.registerLazySingleton<NotificationDao>(() => getIt<AppDatabase>().notificationDao);
  getIt.registerLazySingleton<RepeatDao>(() => getIt<AppDatabase>().repeatDao);
  
  // Core Services
  getIt.registerLazySingleton<FlutterLocalNotification>(() => FlutterLocalNotification());

  // ========== Data Layer ==========
  
  // Repositories
  getIt.registerLazySingleton<ExampleRepository>(() => ExampleRepositoryImpl());
  
  getIt.registerLazySingleton<ItemRepository>(() => ItemRepositoryImpl(
    getIt<ItemDao>(),
  ));
  
  getIt.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(
    getIt<CategoryDao>(),
    getIt<ItemDao>(),
  ));
  
  getIt.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(
    getIt<NotificationDao>(),
  ));
  
  getIt.registerLazySingleton<RepeatRepository>(() => RepeatRepositoryImpl(
    getIt<RepeatDao>(),
    getIt<ItemDao>(),
  ));

  // ========== Domain Layer ==========
  
  // Use Cases
  getIt.registerLazySingleton<GetExampleUsecase>(
    () => GetExampleUsecase(repository: getIt<ExampleRepository>()),
  );
  
  // Item Use Cases
  getIt.registerLazySingleton<GetItemsUsecase>(
    () => GetItemsUsecase(repository: getIt<ItemRepository>()),
  );
  
  getIt.registerLazySingleton<SaveItemUsecase>(
    () => SaveItemUsecase(repository: getIt<ItemRepository>()),
  );
  
  getIt.registerLazySingleton<GetAllItemsUsecase>(
    () => GetAllItemsUsecase(getIt<ItemRepository>()),
  );
  
  // Notification Use Cases
  getIt.registerLazySingleton<GetNotificationsUsecase>(
    () => GetNotificationsUsecase(repository: getIt<NotificationRepository>()),
  );
  
  // Alarm Use Cases
  getIt.registerLazySingleton<SetAlarmUsecase>(
    () => SetAlarmUsecase(),
  );
  
  getIt.registerLazySingleton<DeleteAlarmUsecase>(
    () => DeleteAlarmUsecase(),
  );

  // ========== Presentation Layer ==========
  
  // BLoCs
  getIt.registerFactory<ExampleBloc>(
    () => ExampleBloc(getExampleUsecase: getIt<GetExampleUsecase>()),
  );
  
  getIt.registerFactory<AlarmBloc>(
    () => AlarmBloc(getIt<SetAlarmUsecase>()),
  );
}