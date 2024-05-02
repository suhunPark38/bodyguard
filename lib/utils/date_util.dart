
/// 싱글톤 클래스. DateTime 관련한 유틸 함수 모음
class DateUtil {
  static final DateUtil _instance = DateUtil._internal();

  factory DateUtil(){
    return _instance;
  }

  DateUtil._internal();

  /// 입력 값의 시,분을 현재 시간으로 바꿔 리턴
  DateTime updateDateTimeToNow(DateTime dateTime) {
    /// 로컬 시간에서 시:분 정보만 가져와서 DateTime 값을 수정한다
    /// toUtc로 해야 한국 시간대로 제대로 입력된다
    DateTime now = DateTime.now().toUtc();
    return dateTime.copyWith(hour: now.hour, minute: now.minute);
  }

}