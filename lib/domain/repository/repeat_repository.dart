import 'package:reminder/domain/entities/repeat.dart';
import 'package:reminder/domain/entities/item.dart';

abstract class RepeatRepository {
  /// 모든 반복 설정 조회
  Future<List<Repeat>> getAllRepeats();
  
  /// ID로 반복 설정 조회
  Future<Repeat?> getRepeatById(int id);
  
  /// 반복 설정 저장 (생성/수정)
  Future<Repeat> saveRepeat(Repeat repeat);
  
  /// 반복 설정 수정
  Future<Repeat> updateRepeat(Repeat repeat);
  
  /// 반복 설정 삭제
  Future<void> deleteRepeat(int id);
  
  /// 특정 반복 설정을 사용하는 아이템들 조회
  Future<List<Item>> getItemsByRepeat(int repeatId);
  
  /// 특정 반복 설정을 사용하는 아이템 개수 조회
  Future<int> getItemCountByRepeat(int repeatId);
  
  /// 활성화된 반복 설정들 조회 (현재 기간 내)
  Future<List<Repeat>> getActiveRepeats();
  
  /// 만료된 반복 설정들 조회
  Future<List<Repeat>> getExpiredRepeats();
  
  /// 특정 날짜에 해당하는 반복 설정들 조회 (YYYY_MM_DD_hh_mm format)
  Future<List<Repeat>> getRepeatsByDate(String date);
  
  /// 주간 반복 설정들 조회
  Future<List<Repeat>> getWeeklyRepeats();
  
  /// 월간 반복 설정들 조회  
  Future<List<Repeat>> getMonthlyRepeats();
  
  /// 반복 설정 사용 여부 확인 (삭제 전 체크용)
  Future<bool> isRepeatInUse(int repeatId);
  
  /// 다음 반복 일정 계산 (YYYY_MM_DD_hh_mm format)
  Future<String?> getNextRepeatDate(int repeatId, String fromDate);
}
