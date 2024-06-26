import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

import '../database/local_database.dart';
import '../model/diet_record.dart';
import '../utils/calculate_util.dart';
import '../utils/notification.dart';

class DietProvider with ChangeNotifier {
  List<DietData> _diets = [];
  List<DietData> _breakfast = [];
  List<DietData> _lunch = [];
  List<DietData> _dinner = [];
  DietRecord _totalNutritionalInfo = DietRecord(
      calories: 0, carbohydrates: 0, protein: 0, fat: 0, sodium: 0, sugar: 0);
  DateTime _eatingTime = DateTime.now();

  bool _disposed = false;

  final database = LocalDatabase.instance;
  bool _notificationSent = false; //앱 실행 동안 한 번만 알림 판별 변수


  DateTime _focusedDay = DateTime.now(); //현재 표시할 월
  DateTime _selectedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  CalendarFormat _calendarFormat = CalendarFormat.week;

  List<DietData> _breakfastForPeriod = [];
  List<DietData> _lunchForPeriod = [];
  List<DietData> _dinnerForPeriod = [];

  double _recommendedCalories = 2000;

  double _todayCalories = 0.0;

  double _averageCaloriesForWeek = 0.0;
  double _averageCaloriesForMonth = 0.0;

  List<DietData> get diets => _diets;

  List<DietData> get breakfast => _breakfast;

  List<DietData> get lunch => _lunch;

  List<DietData> get dinner => _dinner;

  DietRecord get totalNutritionalInfo => _totalNutritionalInfo;

  double get recommendedCalories => _recommendedCalories;
  
  set recommendedCalories(double value){
    _recommendedCalories = value;
  }
  DateTime get focusedDay => _focusedDay;

  DateTime get selectedDay => _selectedDay;

  CalendarFormat get calendarFormat => _calendarFormat;

  List<DietData> get breakfastForPeriod => _breakfastForPeriod;

  List<DietData> get lunchForPeriod => _lunchForPeriod;

  List<DietData> get dinnerForPeriod => _dinnerForPeriod;

  double get todayCalories => _todayCalories;

  double get averageCaloriesForWeek => _averageCaloriesForWeek;

  double get averageCaloriesForMonth => _averageCaloriesForMonth;



  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void setSelectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  DietProvider() {
    _updateDietsList(_eatingTime);
    _updateDietsListForPeriod(_eatingTime);
    _updateTodayCalories();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void updateCalendarFormat(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  double calculateCaloriesPercentage() {
    return (_totalNutritionalInfo.calories / _recommendedCalories)
        .clamp(0.0, 1.0);
  }

  // 식단 데이터 조회
  void notifySelectDiets(DateTime eatingTime) async {
    _eatingTime = eatingTime;
    _updateDietsList(_eatingTime);
    _updateDietsListForPeriod(_eatingTime);
  }

  /// 식단 데이터 삽입
  void notifyInsertDiet(DietCompanion dietCompanion) {
    database.insertDiet(dietCompanion);
    _updateDietsList(_eatingTime);
    _updateDietsListForPeriod(_eatingTime);
  }

  /// 식단 데이터 삭제
  void notifyDeleteDiet(int dietId) {
    database.deleteDiet(dietId);
    _updateDietsList(_eatingTime);
    _updateDietsListForPeriod(_eatingTime);
  }

  // 식단 데이터 수정
  void notifyUpdateDiet(DietCompanion dietCompanion) {
    database.updateDiet(dietCompanion, dietCompanion.dietId.value);
    _updateDietsList(_eatingTime);
    _updateDietsListForPeriod(_eatingTime);
  }

  void _updateTodayCalories() async {
    DateTime today = DateTime.now();
    List<DietData> todayDiets = await database.getDietByEatingTime(today);
    double todayCalories = CalculateUtil()
        .getSumOfLists(todayDiets.map((diet) => diet.calories).toList());

    if (todayCalories > _recommendedCalories && !_notificationSent) {
      _notificationSent = true;
      FlutterLocalNotification.showNotification(
          1, "칼로리 알림", "칼로리 경고", "오늘의 섭취 칼로리가 권장 칼로리를 초과하였습니다.");
    }

    _todayCalories = todayCalories;
  }

  void _updateDietsListForPeriod(DateTime selectedDate) async {
    //기한 지정함으로서 앱의 부담을 줄이기 위함
    DateTime start;
    DateTime end;

    start = DateTime(selectedDate.year, selectedDate.month, 1); // 해당 달의 시작일로 설정
    end = DateTime(
        selectedDate.year, selectedDate.month + 1, 0); // 해당 달의 마지막 날로 설정

    _breakfastForPeriod = await database.getBreakfastForPeriod(start, end);
    _lunchForPeriod = await database.getLunchForPeriod(start, end);
    _dinnerForPeriod = await database.getDinnerForPeriod(start, end);
    notifyListeners();
  }

  /// 식단 데이터 변경이 일어날 때마다 각 list 최신화
  void _updateDietsList(DateTime eatingTime) async {
    _diets = await database.getDietByEatingTime(eatingTime);
    _breakfast = _diets.where((diet) => diet.classification == 0).toList();
    _lunch = _diets.where((diet) => diet.classification == 1).toList();
    _dinner = _diets.where((diet) => diet.classification == 2).toList();

    _updateTodayCalories();
    _updateAverages();
    _totalNutritionalInfo = DietRecord(
      calories: CalculateUtil()
          .getSumOfLists(_diets.map((diet) => diet.calories).toList()),
      carbohydrates: CalculateUtil()
          .getSumOfLists(_diets.map((diet) => diet.carbohydrate).toList()),
      protein: CalculateUtil()
          .getSumOfLists(_diets.map((diet) => diet.protein).toList()),
      fat: CalculateUtil()
          .getSumOfLists(_diets.map((diet) => diet.fat).toList()),
      sodium: CalculateUtil()
          .getSumOfLists(_diets.map((diet) => diet.sodium).toList()),
      sugar: CalculateUtil()
          .getSumOfLists(_diets.map((diet) => diet.sugar).toList()),
    );
    notifyListeners();
  }
  void _updateAverages() async {
    _averageCaloriesForWeek = await getAverageCaloriesForWeek();
    _averageCaloriesForMonth = await getAverageCaloriesForMonth();
  }

  Future<double> getAverageCaloriesForWeek() async {
    // 현재 날짜의 요일 계산
    int currentWeekday = selectedDay.weekday;

    // 현재 주의 첫 번째 날 계산
    DateTime firstDayOfCurrentWeek = selectedDay.subtract(Duration(days: currentWeekday - 1));
    // 현재 주의 마지막 날 계산
    DateTime lastDayOfCurrentWeek = firstDayOfCurrentWeek.add(Duration(days: 6));

    // 일주일 동안의 다이어트 데이터 가져오기
    List<DietData> weekDiets = await database.getDietBetweenDates(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
    // 주간 다이어트가 있는 날의 개수
    int weekDataCount = _calculateNonEmptyDaysCount(weekDiets);

    // 주간 칼로리 합계 구하기
    double weekCaloriesSum = _calculateCaloriesSum(weekDiets);

    // 주간 평균 칼로리 계산 (데이터가 없으면 0으로 처리)
    double averageCaloriesForWeek = weekDataCount > 0 ? weekCaloriesSum / weekDataCount : 0.0;

    return averageCaloriesForWeek;
  }

  Future<double> getAverageCaloriesForMonth() async {
    // 현재 월의 첫 번째 날 계산
    DateTime firstDayOfCurrentMonth = DateTime(selectedDay.year, selectedDay.month, 1);
    // 현재 월의 마지막 날 계산
    DateTime lastDayOfCurrentMonth = DateTime(selectedDay.year, selectedDay.month + 1, 0);

    // 한 달 동안의 다이어트 데이터 가져오기
    List<DietData> monthDiets = await database.getDietBetweenDates(firstDayOfCurrentMonth, lastDayOfCurrentMonth);
    // 한 달 동안 다이어트가 있는 날의 개수
    int monthDataCount = _calculateNonEmptyDaysCount(monthDiets);

    // 한 달 칼로리 합계 구하기
    double monthCaloriesSum = _calculateCaloriesSum(monthDiets);

    // 월간 평균 칼로리 계산 (데이터가 없으면 0으로 처리)
    double averageCaloriesForMonth = monthDataCount > 0 ? monthCaloriesSum / monthDataCount : 0.0;

    return averageCaloriesForMonth;
  }

  int _calculateNonEmptyDaysCount(List<DietData> dietData) {
    Set<String> uniqueDates = Set(); // 중복된 날짜를 방지하기 위해 Set을 사용합니다.
    for (DietData data in dietData) {
      // DietData 객체의 eatingTime 필드에서 날짜 정보를 추출합니다.
      String date = '${data.eatingTime.year}-${data.eatingTime.month}-${data.eatingTime.day}';
      uniqueDates.add(date);
    }
    return uniqueDates.length; // 중복을 제거한 날짜의 개수를 반환합니다.
  }


  double _calculateCaloriesSum(List<DietData> diets) {
    double sum = 0.0;
    for (var diet in diets) {
      sum += diet.calories;
    }
    return sum;
  }

  String getWeeklyCaloriesComparisonMessage(double todayCalories, double weekAverage) {
    double difference = (todayCalories - weekAverage).abs();
    if (todayCalories < weekAverage) {
      return "주간 평균보다 ${difference.toStringAsFixed(1)} kcal 적게";
    } else if (todayCalories > weekAverage) {
      return "주간 평균보다 ${difference.toStringAsFixed(1)} kcal 많이";
    } else {
      return "주간 평균과 같은 양을";
    }
  }


  String getMonthlyCaloriesComparisonMessage(double todayCalories, double monthAverage) {
    double difference = (todayCalories - monthAverage).abs();

    if (todayCalories < monthAverage) {
      return "월간 평균보다 ${difference.toStringAsFixed(1)} kcal 적게";
    } else if (todayCalories > monthAverage) {
      return "월간 평균보다 ${difference.toStringAsFixed(1)} kcal 많이";
    } else {
      return "월간 평균과 같은 양을";
    }
  }
}
