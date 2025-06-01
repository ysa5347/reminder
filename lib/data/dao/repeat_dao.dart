import 'package:floor/floor.dart';
import '../model/repeat_model.dart';

@dao
abstract class RepeatDao {
  @Query('SELECT * FROM repeats')
  Future<List<RepeatModel>> getAllRepeats();

  @Query('SELECT * FROM repeats WHERE id = :id')
  Future<RepeatModel?> getRepeatById(int id);

  @Query('SELECT * FROM repeats WHERE start_day <= :currentTime AND (end_day IS NULL OR end_day >= :currentTime)')
  Future<List<RepeatModel>> getActiveRepeats(int currentTime);

  @Query('SELECT * FROM repeats WHERE end_day IS NOT NULL AND end_day < :currentTime')
  Future<List<RepeatModel>> getExpiredRepeats(int currentTime);

  @Query('SELECT * FROM repeats WHERE weekday_byte IS NOT NULL AND weekday_byte != 0')
  Future<List<RepeatModel>> getWeeklyRepeats();

  @Query('SELECT * FROM repeats WHERE week_byte IS NOT NULL AND week_byte != 0')
  Future<List<RepeatModel>> getMonthlyRepeats();

  @Query('SELECT COUNT(*) FROM items WHERE repeat_id = :repeatId')
  Future<int?> getItemCountByRepeat(int repeatId);

  @insert
  Future<int> insertRepeat(RepeatModel repeat);

  @update
  Future<int> updateRepeat(RepeatModel repeat);

  @Query('DELETE FROM repeats WHERE id = :id')
  Future<int?> deleteRepeat(int id);

  @Query('SELECT COUNT(*) FROM items WHERE repeat_id = :repeatId')
  Future<int?> checkRepeatUsage(int repeatId);
}
