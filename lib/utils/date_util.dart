
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

  /// 시간 입력 받아서 구분하기
  String getMealTime(DateTime date){
    String mealTimeDetails = '';
    int hour = date.hour;

    if (hour >= 7 && hour < 12) {
      mealTimeDetails =  '아침을 주문할까요?';
    } else if (hour >= 12 && hour < 17) {
      mealTimeDetails =  '점심을 주문할까요?';
    } else if (hour >= 17 && hour < 22) {
      mealTimeDetails =  '저녁을 주문할까요?';
    } else {
      mealTimeDetails =  '메뉴를 주문할까요?';
    }

    return mealTimeDetails;
  }

}