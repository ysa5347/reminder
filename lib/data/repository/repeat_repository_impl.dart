import 'package:reminder/domain/repository/repeat_repository.dart';
import 'package:reminder/domain/entities/repeat.dart';
import 'package:reminder/domain/entities/item.dart';
import 'package:reminder/data/dao/repeat_dao.dart';
import 'package:reminder/data/dao/item_dao.dart';
import 'package:reminder/data/model/repeat_model.dart';
import 'package:reminder/data/model/item_model.dart';

class RepeatRepositoryImpl implements RepeatRepository {
  final RepeatDao _repeatDao;
  final ItemDao _itemDao;

  RepeatRepositoryImpl(this._repeatDao, this._itemDao);

  @override
  Future<List<Repeat>> getAllRepeats() async {
    final repeatModels = await _repeatDao.getAllRepeats();
    return repeatModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<Repeat?> getRepeatById(int id) async {
    final repeatModel = await _repeatDao.getRepeatById(id);
    return repeatModel != null ? _mapModelToEntity(repeatModel) : null;
  }

  @override
  Future<Repeat> saveRepeat(Repeat repeat) async {
    final repeatModel = _mapEntityToModel(repeat);
    final id = await _repeatDao.insertRepeat(repeatModel);
    
    final savedModel = repeatModel.copyWith(id: id);
    return _mapModelToEntity(savedModel);
  }

  @override
  Future<Repeat> updateRepeat(Repeat repeat) async {
    final repeatModel = _mapEntityToModel(repeat);
    await _repeatDao.updateRepeat(repeatModel);
    return repeat;
  }

  @override
  Future<void> deleteRepeat(int id) async {
    await _repeatDao.deleteRepeat(id);
  }

  @override
  Future<List<Item>> getItemsByRepeat(int repeatId) async {
    final itemModels = await _itemDao.getItemsByRepeat(repeatId);
    return itemModels.map((model) => _mapItemModelToEntity(model)).toList();
  }

  @override
  Future<int> getItemCountByRepeat(int repeatId) async {
    final count = await _repeatDao.getItemCountByRepeat(repeatId);
    return count ?? 0;
  }

  @override
  Future<List<Repeat>> getActiveRepeats() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final repeatModels = await _repeatDao.getActiveRepeats(currentTime);
    return repeatModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Repeat>> getExpiredRepeats() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final repeatModels = await _repeatDao.getExpiredRepeats(currentTime);
    return repeatModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Repeat>> getRepeatsByDate(String date) async {
    // Parse date string and check against repeat patterns
    final targetDate = _parseStringToDateTime(date);
    final activeRepeats = await getActiveRepeats();
    
    return activeRepeats.where((repeat) {
      return _isDateMatchingRepeat(targetDate, repeat);
    }).toList();
  }

  @override
  Future<List<Repeat>> getWeeklyRepeats() async {
    final repeatModels = await _repeatDao.getWeeklyRepeats();
    return repeatModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Repeat>> getMonthlyRepeats() async {
    final repeatModels = await _repeatDao.getMonthlyRepeats();
    return repeatModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<bool> isRepeatInUse(int repeatId) async {
    final count = await _repeatDao.checkRepeatUsage(repeatId);
    return (count ?? 0) > 0;
  }

  @override
  Future<String?> getNextRepeatDate(int repeatId, String fromDate) async {
    final repeat = await getRepeatById(repeatId);
    if (repeat == null) return null;

    final fromDateTime = _parseStringToDateTime(fromDate);
    final nextDate = _calculateNextRepeatDate(repeat, fromDateTime);
    
    return nextDate != null ? _formatDateTimeToString(nextDate) : null;
  }

  // Helper methods for mapping
  Repeat _mapModelToEntity(RepeatModel model) {
    return Repeat(
      id: model.id,
      weekdayByte: model.weekdayByte,
      weekByte: model.weekByte,
      createdAt: model.createdAt != null 
          ? _formatMillisecondsToString(model.createdAt!)
          : null,
      updatedAt: model.updatedAt != null 
          ? _formatMillisecondsToString(model.updatedAt!)
          : null,
      startDay: model.startDay != null 
          ? _formatMillisecondsToString(model.startDay!)
          : null,
      endDay: model.endDay != null 
          ? _formatMillisecondsToString(model.endDay!)
          : null,
    );
  }

  RepeatModel _mapEntityToModel(Repeat entity) {
    return RepeatModel(
      id: entity.id,
      weekdayByte: entity.weekdayByte,
      weekByte: entity.weekByte,
      createdAt: entity.createdAt != null 
          ? _parseStringToDateTime(entity.createdAt!).millisecondsSinceEpoch
          : null,
      updatedAt: entity.updatedAt != null 
          ? _parseStringToDateTime(entity.updatedAt!).millisecondsSinceEpoch
          : null,
      startDay: entity.startDay != null 
          ? _parseStringToDateTime(entity.startDay!).millisecondsSinceEpoch
          : null,
      endDay: entity.endDay != null 
          ? _parseStringToDateTime(entity.endDay!).millisecondsSinceEpoch
          : null,
    );
  }

  Item _mapItemModelToEntity(ItemModel model) {
    return Item(
      id: model.id,
      title: model.title,
      description: model.description,
      createdAt: model.createdAt != null 
          ? _formatMillisecondsToString(model.createdAt!)
          : null,
      updatedAt: model.updatedAt != null 
          ? _formatMillisecondsToString(model.updatedAt!)
          : null,
      due: model.due != null 
          ? _formatMillisecondsToString(model.due!)
          : null,
      completedAt: model.completedAt != null 
          ? _formatMillisecondsToString(model.completedAt!)
          : null,
      flag: model.flag,
      priority: model.priority,
      repeatId: model.repeatId,
      parentId: model.parentId,
      categoryId: model.categoryId,
    );
  }

  // Helper methods for date formatting and parsing
  String _formatMillisecondsToString(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return _formatDateTimeToString(dateTime);
  }

  String _formatDateTimeToString(DateTime dateTime) {
    return '${dateTime.year}_${dateTime.month.toString().padLeft(2, '0')}_${dateTime.day.toString().padLeft(2, '0')}_${dateTime.hour.toString().padLeft(2, '0')}_${dateTime.minute.toString().padLeft(2, '0')}';
  }

  DateTime _parseStringToDateTime(String dateString) {
    final parts = dateString.split('_');
    return DateTime(
      int.parse(parts[0]), // year
      int.parse(parts[1]), // month
      int.parse(parts[2]), // day
      int.parse(parts[3]), // hour
      int.parse(parts[4]), // minute
    );
  }

  bool _isDateMatchingRepeat(DateTime date, Repeat repeat) {
    // Check if date matches weekday pattern
    if (repeat.weekdayByte != null && repeat.weekdayByte! > 0) {
      final weekday = date.weekday; // 1 = Monday, 7 = Sunday
      final weekdayBit = 1 << (weekday - 1);
      if ((repeat.weekdayByte! & weekdayBit) != 0) {
        return true;
      }
    }

    // Check if date matches monthly pattern
    if (repeat.weekByte != null && repeat.weekByte! > 0) {
      final weekOfMonth = ((date.day - 1) ~/ 7) + 1;
      final weekBit = 1 << (weekOfMonth - 1);
      if ((repeat.weekByte! & weekBit) != 0) {
        return true;
      }
    }

    return false;
  }

  DateTime? _calculateNextRepeatDate(Repeat repeat, DateTime fromDate) {
    // Simple implementation for next occurrence
    // This can be enhanced based on specific repeat logic requirements
    
    if (repeat.weekdayByte != null && repeat.weekdayByte! > 0) {
      // Find next matching weekday
      for (int i = 1; i <= 7; i++) {
        final nextDate = fromDate.add(Duration(days: i));
        if (_isDateMatchingRepeat(nextDate, repeat)) {
          return nextDate;
        }
      }
    }

    if (repeat.weekByte != null && repeat.weekByte! > 0) {
      // Find next matching week of month
      final nextMonth = DateTime(fromDate.year, fromDate.month + 1, 1);
      for (int day = 1; day <= 31; day++) {
        try {
          final nextDate = DateTime(nextMonth.year, nextMonth.month, day);
          if (_isDateMatchingRepeat(nextDate, repeat)) {
            return nextDate;
          }
        } catch (e) {
          break; // Invalid date
        }
      }
    }

    return null;
  }
}

extension RepeatModelExtension on RepeatModel {
  RepeatModel copyWith({
    int? id,
    int? weekdayByte,
    int? weekByte,
    int? createdAt,
    int? updatedAt,
    int? startDay,
    int? endDay,
  }) {
    return RepeatModel(
      id: id ?? this.id,
      weekdayByte: weekdayByte ?? this.weekdayByte,
      weekByte: weekByte ?? this.weekByte,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
    );
  }
}
