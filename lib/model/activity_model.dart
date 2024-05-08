import 'package:drift/drift.dart';

class ActivityData {
  final double weight;
  final double runningTime;
  final double caloriesBurned; // 추가된 변수
  final double bikingTime;
  final double BcaloriesBurned; // 추가된 변수
  final int steps; // 추가된 변수

  ActivityData({
    required this.weight,
    required this.runningTime,
    required this.caloriesBurned,
    required this.bikingTime,
    required this.BcaloriesBurned,
    required this.steps,
  });

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'runningTime': runningTime,
      'caloriesBurned': caloriesBurned,
      'bikingTime': bikingTime,
      'BcaloriesBurned': BcaloriesBurned,
      'steps': steps,
    };
  }

  factory ActivityData.fromMap(Map<String, dynamic> map) {
    return ActivityData(
      weight: map['weight'] ?? 70,
      runningTime: map['runningTime'] ?? 0,
      caloriesBurned: map['caloriesBurned'] ?? 0,
      bikingTime: map['bikingTime'] ?? 0,
      BcaloriesBurned: map['BcaloriesBurned'] ?? 0,
      steps: map['steps'] ?? 0,
    );
  }

 /* ActivityData copyWith({
    double? weight,
    double? runningTime,
    double? caloriesBurned,
    double? bikingTime,
    double? BcaloriesBurned,
    int? steps,
  }) {
    return ActivityData(
      weight: weight ?? this.weight,
      runningTime: runningTime ?? this.runningTime,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      bikingTime: bikingTime ?? this.bikingTime,
      BcaloriesBurned: BcaloriesBurned ?? this.BcaloriesBurned,
      steps: steps ?? this.steps,
    );
  }*/

  ActivityData updateSteps(int newSteps) {
    return ActivityData(
      weight: this.weight,
      runningTime: this.runningTime,
      caloriesBurned: this.caloriesBurned,
      bikingTime: this.bikingTime,
      BcaloriesBurned: this.BcaloriesBurned,
      steps: newSteps,
    );
  }


}


/*class Activity extends Table {
  DateTimeColumn get recordDate => dateTime()();
  TextColumn get activityName => text()();
  RealColumn get calorieBurned => real()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get steps => integer()(); // 걸음 수
  RealColumn get weight => real()(); // 체중
  RealColumn get runningTime => real()(); // 달리기 시간
  RealColumn get runningCaloriesBurned => real()(); // 달리기로 소비된 칼로리
  RealColumn get bikingTime => real()(); // 자전거 시간
  RealColumn get bikingCaloriesBurned => real()(); // 자전거로 소비된 칼로리

  @override
  Set<Column> get primaryKey => {recordDate};

  void updateFromMap(Map<String, dynamic> data) {}
}*/
