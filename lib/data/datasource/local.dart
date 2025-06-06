import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/item_dao.dart';
import '../dao/category_dao.dart'; 
import '../dao/notification_dao.dart';
import '../dao/repeat_dao.dart';

import '../model/item_model.dart';
import '../model/category_model.dart'; 
import '../model/notification_model.dart';
import '../model/repeat_model.dart';

part 'local.g.dart';

@Database(
  version: 1, 
  entities: [
    ItemModel,
    CategoryModel,
    NotificationModel,
    RepeatModel,
  ]
)
abstract class AppDatabase extends FloorDatabase {
  ItemDao get itemDao;
  CategoryDao get categoryDao;
  NotificationDao get notificationDao;
  RepeatDao get repeatDao;
}
