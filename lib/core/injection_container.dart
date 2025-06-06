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
import 'package:reminder/domain/usecase/notification/save_notification_usecase.dart';
import 'package:reminder/domain/usecase/notification/delete_notification_usecase.dart';
import 'package:reminder/domain/usecase/item/GetItems_usecase.dart';
import 'package:reminder/domain/usecase/item/SaveItem_usecase.dart';
import 'package:reminder/domain/usecase/item/get_all_items_usecase.dart';
import 'package:reminder/domain/usecase/item/get_items_by_type_usecase.dart';
import 'package:reminder/domain/usecase/item/update_item_usecase.dart';
import 'package:reminder/domain/usecase/item/delete_item_usecase.dart';
import 'package:reminder/domain/usecase/item/search_items_usecase.dart';
import 'package:reminder/domain/usecase/Alarm/SetAlarm_usecase.dart';
import 'package:reminder/domain/usecase/Alarm/DeleteAlarm_usecase.dart';
import 'package:reminder/domain/usecase/category/get_categories_usecase.dart';
import 'package:reminder/domain/usecase/category/save_category_usecase.dart';
import 'package:reminder/domain/usecase/category/update_category_usecase.dart';
import 'package:reminder/domain/usecase/category/delete_category_usecase.dart';

// BLoCs
import 'package:reminder/presentation/blocs/example/example_bloc.dart';
import 'package:reminder/presentation/blocs/alarm/alarm_bloc.dart';
import 'package:reminder/presentation/blocs/main/main_bloc.dart';
import 'package:reminder/presentation/blocs/category/category_bloc.dart';
import 'package:reminder/presentation/blocs/item_list/item_list_bloc.dart';

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
  
  getIt.registerLazySingleton<GetItemsByTypeUsecase>(
    () => GetItemsByTypeUsecase(repository: getIt<ItemRepository>()),
  );
  
  getIt.registerLazySingleton<UpdateItemUsecase>(
    () => UpdateItemUsecase(repository: getIt<ItemRepository>()),
  );
  
  getIt.registerLazySingleton<DeleteItemUsecase>(
    () => DeleteItemUsecase(repository: getIt<ItemRepository>()),
  );
  
  getIt.registerLazySingleton<SearchItemsUsecase>(
    () => SearchItemsUsecase(repository: getIt<ItemRepository>()),
  );
  
  // Notification Use Cases
  getIt.registerLazySingleton<GetNotificationsUsecase>(
    () => GetNotificationsUsecase(repository: getIt<NotificationRepository>()),
  );
  
  getIt.registerLazySingleton<SaveNotificationUsecase>(
    () => SaveNotificationUsecase(repository: getIt<NotificationRepository>()),
  );
  
  getIt.registerLazySingleton<DeleteNotificationUsecase>(
    () => DeleteNotificationUsecase(repository: getIt<NotificationRepository>()),
  );
  
  // Alarm Use Cases
  getIt.registerLazySingleton<SetAlarmUsecase>(
    () => SetAlarmUsecase(),
  );
  
  getIt.registerLazySingleton<DeleteAlarmUsecase>(
    () => DeleteAlarmUsecase(),
  );
  
  // Category Use Cases
  getIt.registerLazySingleton<GetCategoriesUsecase>(
    () => GetCategoriesUsecase(repository: getIt<CategoryRepository>()),
  );
  
  getIt.registerLazySingleton<SaveCategoryUsecase>(
    () => SaveCategoryUsecase(repository: getIt<CategoryRepository>()),
  );
  
  getIt.registerLazySingleton<UpdateCategoryUsecase>(
    () => UpdateCategoryUsecase(repository: getIt<CategoryRepository>()),
  );
  
  getIt.registerLazySingleton<DeleteCategoryUsecase>(
    () => DeleteCategoryUsecase(repository: getIt<CategoryRepository>()),
  );

  // ========== Presentation Layer ==========
  
  // BLoCs
  getIt.registerFactory<ExampleBloc>(
    () => ExampleBloc(getExampleUsecase: getIt<GetExampleUsecase>()),
  );
  
  getIt.registerFactory<AlarmBloc>(
    () => AlarmBloc(
      setAlarmUsecase: getIt<SetAlarmUsecase>(),
      deleteAlarmUsecase: getIt<DeleteAlarmUsecase>(),
      notificationRepository: getIt<NotificationRepository>(),
    ),
  );
  
  getIt.registerFactory<MainBloc>(
    () => MainBloc(getCategoriesUsecase: getIt<GetCategoriesUsecase>()),
  );
  
  getIt.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      getCategoriesUsecase: getIt<GetCategoriesUsecase>(),
      saveCategoryUsecase: getIt<SaveCategoryUsecase>(),
      updateCategoryUsecase: getIt<UpdateCategoryUsecase>(),
      deleteCategoryUsecase: getIt<DeleteCategoryUsecase>(),
    ),
  );
  
  getIt.registerFactory<ItemListBloc>(
    () => ItemListBloc(
      getItemsByTypeUsecase: getIt<GetItemsByTypeUsecase>(),
      searchItemsUsecase: getIt<SearchItemsUsecase>(),
      saveItemUsecase: getIt<SaveItemUsecase>(),
      updateItemUsecase: getIt<UpdateItemUsecase>(),
      deleteItemUsecase: getIt<DeleteItemUsecase>(),
      saveNotificationUsecase: getIt<SaveNotificationUsecase>(),
      deleteNotificationUsecase: getIt<DeleteNotificationUsecase>(),
      setAlarmUsecase: getIt<SetAlarmUsecase>(),
      deleteAlarmUsecase: getIt<DeleteAlarmUsecase>(),
    ),
  );
}