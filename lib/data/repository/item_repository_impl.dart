import 'package:reminder/domain/repository/item_repository.dart';
import 'package:reminder/domain/entities/item.dart';

class ItemRepositoryImpl extends ItemRepository {
  @override
  Future<List<Item>> getAllItems() async {
    throw UnimplementedError();
  }
  @override
  Future<List<Item>> GetItemsById(int itemId) async {
    // TODO: itemId를 통해 데이터베이스에서 데이터를 가져옴
    throw UnimplementedError();
  }

  @override
  Future<Item> SaveItem(Item item) async {
    // TODO: item을 데이터베이스에 저장
    throw UnimplementedError();
  }

  @override
  Future<Item> DeleteItem(int itemId) async {
    // TODO: itemId를 통해 데이터베이스에서 데이터를 삭제
    throw UnimplementedError();
  }
}
/*
class AlarmRepositoryImpl extends AlarmRepository{ //실제 알람이 울리도록 하는 것
  @override
  Future<void> SetAlarmByNotificationId(Notification notification) async {
    // TODO: timeValue를 통해 알람을 설정, time value는 yyyy_mm_dd_hh_mm 형식으로 저장되어 있음
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAlarmByNotificationId(int notificationId) async {
    // TODO: notificationId를 통해 알람을 삭제
    throw UnimplementedError();
  }
}
*/