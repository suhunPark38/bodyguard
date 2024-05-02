// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_database.dart';

// ignore_for_file: type=lint
class $DietTable extends Diet with TableInfo<$DietTable, DietData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DietTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dietIdMeta = const VerificationMeta('dietId');
  @override
  late final GeneratedColumn<int> dietId = GeneratedColumn<int>(
      'diet_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _eatingTimeMeta =
      const VerificationMeta('eatingTime');
  @override
  late final GeneratedColumn<DateTime> eatingTime = GeneratedColumn<DateTime>(
      'eating_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _menuNameMeta =
      const VerificationMeta('menuName');
  @override
  late final GeneratedColumn<String> menuName = GeneratedColumn<String>(
      'menu_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _classficationMeta =
      const VerificationMeta('classfication');
  @override
  late final GeneratedColumn<int> classfication = GeneratedColumn<int>(
      'classfication', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _caloriesMeta =
      const VerificationMeta('calories');
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
      'calories', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _carbohydrateMeta =
      const VerificationMeta('carbohydrate');
  @override
  late final GeneratedColumn<double> carbohydrate = GeneratedColumn<double>(
      'carbohydrate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _proteinMeta =
      const VerificationMeta('protein');
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
      'protein', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
      'fat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sodiumMeta = const VerificationMeta('sodium');
  @override
  late final GeneratedColumn<double> sodium = GeneratedColumn<double>(
      'sodium', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sugarMeta = const VerificationMeta('sugar');
  @override
  late final GeneratedColumn<double> sugar = GeneratedColumn<double>(
      'sugar', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        dietId,
        eatingTime,
        menuName,
        amount,
        classfication,
        calories,
        carbohydrate,
        protein,
        fat,
        sodium,
        sugar
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diet';
  @override
  VerificationContext validateIntegrity(Insertable<DietData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('diet_id')) {
      context.handle(_dietIdMeta,
          dietId.isAcceptableOrUnknown(data['diet_id']!, _dietIdMeta));
    }
    if (data.containsKey('eating_time')) {
      context.handle(
          _eatingTimeMeta,
          eatingTime.isAcceptableOrUnknown(
              data['eating_time']!, _eatingTimeMeta));
    } else if (isInserting) {
      context.missing(_eatingTimeMeta);
    }
    if (data.containsKey('menu_name')) {
      context.handle(_menuNameMeta,
          menuName.isAcceptableOrUnknown(data['menu_name']!, _menuNameMeta));
    } else if (isInserting) {
      context.missing(_menuNameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('classfication')) {
      context.handle(
          _classficationMeta,
          classfication.isAcceptableOrUnknown(
              data['classfication']!, _classficationMeta));
    } else if (isInserting) {
      context.missing(_classficationMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(_caloriesMeta,
          calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta));
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('carbohydrate')) {
      context.handle(
          _carbohydrateMeta,
          carbohydrate.isAcceptableOrUnknown(
              data['carbohydrate']!, _carbohydrateMeta));
    } else if (isInserting) {
      context.missing(_carbohydrateMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(_proteinMeta,
          protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta));
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(
          _fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('sodium')) {
      context.handle(_sodiumMeta,
          sodium.isAcceptableOrUnknown(data['sodium']!, _sodiumMeta));
    } else if (isInserting) {
      context.missing(_sodiumMeta);
    }
    if (data.containsKey('sugar')) {
      context.handle(
          _sugarMeta, sugar.isAcceptableOrUnknown(data['sugar']!, _sugarMeta));
    } else if (isInserting) {
      context.missing(_sugarMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dietId};
  @override
  DietData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DietData(
      dietId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}diet_id'])!,
      eatingTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}eating_time'])!,
      menuName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}menu_name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      classfication: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}classfication'])!,
      calories: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}calories'])!,
      carbohydrate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbohydrate'])!,
      protein: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein'])!,
      fat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat'])!,
      sodium: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sodium'])!,
      sugar: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sugar'])!,
    );
  }

  @override
  $DietTable createAlias(String alias) {
    return $DietTable(attachedDatabase, alias);
  }
}

class DietData extends DataClass implements Insertable<DietData> {
  final int dietId;
  final DateTime eatingTime;
  final String menuName;
  final double amount;
  final int classfication;
  final double calories;
  final double carbohydrate;
  final double protein;
  final double fat;
  final double sodium;
  final double sugar;
  const DietData(
      {required this.dietId,
      required this.eatingTime,
      required this.menuName,
      required this.amount,
      required this.classfication,
      required this.calories,
      required this.carbohydrate,
      required this.protein,
      required this.fat,
      required this.sodium,
      required this.sugar});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['diet_id'] = Variable<int>(dietId);
    map['eating_time'] = Variable<DateTime>(eatingTime);
    map['menu_name'] = Variable<String>(menuName);
    map['amount'] = Variable<double>(amount);
    map['classfication'] = Variable<int>(classfication);
    map['calories'] = Variable<double>(calories);
    map['carbohydrate'] = Variable<double>(carbohydrate);
    map['protein'] = Variable<double>(protein);
    map['fat'] = Variable<double>(fat);
    map['sodium'] = Variable<double>(sodium);
    map['sugar'] = Variable<double>(sugar);
    return map;
  }

  DietCompanion toCompanion(bool nullToAbsent) {
    return DietCompanion(
      dietId: Value(dietId),
      eatingTime: Value(eatingTime),
      menuName: Value(menuName),
      amount: Value(amount),
      classfication: Value(classfication),
      calories: Value(calories),
      carbohydrate: Value(carbohydrate),
      protein: Value(protein),
      fat: Value(fat),
      sodium: Value(sodium),
      sugar: Value(sugar),
    );
  }

  factory DietData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DietData(
      dietId: serializer.fromJson<int>(json['dietId']),
      eatingTime: serializer.fromJson<DateTime>(json['eatingTime']),
      menuName: serializer.fromJson<String>(json['menuName']),
      amount: serializer.fromJson<double>(json['amount']),
      classfication: serializer.fromJson<int>(json['classfication']),
      calories: serializer.fromJson<double>(json['calories']),
      carbohydrate: serializer.fromJson<double>(json['carbohydrate']),
      protein: serializer.fromJson<double>(json['protein']),
      fat: serializer.fromJson<double>(json['fat']),
      sodium: serializer.fromJson<double>(json['sodium']),
      sugar: serializer.fromJson<double>(json['sugar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dietId': serializer.toJson<int>(dietId),
      'eatingTime': serializer.toJson<DateTime>(eatingTime),
      'menuName': serializer.toJson<String>(menuName),
      'amount': serializer.toJson<double>(amount),
      'classfication': serializer.toJson<int>(classfication),
      'calories': serializer.toJson<double>(calories),
      'carbohydrate': serializer.toJson<double>(carbohydrate),
      'protein': serializer.toJson<double>(protein),
      'fat': serializer.toJson<double>(fat),
      'sodium': serializer.toJson<double>(sodium),
      'sugar': serializer.toJson<double>(sugar),
    };
  }

  DietData copyWith(
          {int? dietId,
          DateTime? eatingTime,
          String? menuName,
          double? amount,
          int? classfication,
          double? calories,
          double? carbohydrate,
          double? protein,
          double? fat,
          double? sodium,
          double? sugar}) =>
      DietData(
        dietId: dietId ?? this.dietId,
        eatingTime: eatingTime ?? this.eatingTime,
        menuName: menuName ?? this.menuName,
        amount: amount ?? this.amount,
        classfication: classfication ?? this.classfication,
        calories: calories ?? this.calories,
        carbohydrate: carbohydrate ?? this.carbohydrate,
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        sodium: sodium ?? this.sodium,
        sugar: sugar ?? this.sugar,
      );
  @override
  String toString() {
    return (StringBuffer('DietData(')
          ..write('dietId: $dietId, ')
          ..write('eatingTime: $eatingTime, ')
          ..write('menuName: $menuName, ')
          ..write('amount: $amount, ')
          ..write('classfication: $classfication, ')
          ..write('calories: $calories, ')
          ..write('carbohydrate: $carbohydrate, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('sodium: $sodium, ')
          ..write('sugar: $sugar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dietId, eatingTime, menuName, amount,
      classfication, calories, carbohydrate, protein, fat, sodium, sugar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DietData &&
          other.dietId == this.dietId &&
          other.eatingTime == this.eatingTime &&
          other.menuName == this.menuName &&
          other.amount == this.amount &&
          other.classfication == this.classfication &&
          other.calories == this.calories &&
          other.carbohydrate == this.carbohydrate &&
          other.protein == this.protein &&
          other.fat == this.fat &&
          other.sodium == this.sodium &&
          other.sugar == this.sugar);
}

class DietCompanion extends UpdateCompanion<DietData> {
  final Value<int> dietId;
  final Value<DateTime> eatingTime;
  final Value<String> menuName;
  final Value<double> amount;
  final Value<int> classfication;
  final Value<double> calories;
  final Value<double> carbohydrate;
  final Value<double> protein;
  final Value<double> fat;
  final Value<double> sodium;
  final Value<double> sugar;
  const DietCompanion({
    this.dietId = const Value.absent(),
    this.eatingTime = const Value.absent(),
    this.menuName = const Value.absent(),
    this.amount = const Value.absent(),
    this.classfication = const Value.absent(),
    this.calories = const Value.absent(),
    this.carbohydrate = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.sodium = const Value.absent(),
    this.sugar = const Value.absent(),
  });
  DietCompanion.insert({
    this.dietId = const Value.absent(),
    required DateTime eatingTime,
    required String menuName,
    required double amount,
    required int classfication,
    required double calories,
    required double carbohydrate,
    required double protein,
    required double fat,
    required double sodium,
    required double sugar,
  })  : eatingTime = Value(eatingTime),
        menuName = Value(menuName),
        amount = Value(amount),
        classfication = Value(classfication),
        calories = Value(calories),
        carbohydrate = Value(carbohydrate),
        protein = Value(protein),
        fat = Value(fat),
        sodium = Value(sodium),
        sugar = Value(sugar);
  static Insertable<DietData> custom({
    Expression<int>? dietId,
    Expression<DateTime>? eatingTime,
    Expression<String>? menuName,
    Expression<double>? amount,
    Expression<int>? classfication,
    Expression<double>? calories,
    Expression<double>? carbohydrate,
    Expression<double>? protein,
    Expression<double>? fat,
    Expression<double>? sodium,
    Expression<double>? sugar,
  }) {
    return RawValuesInsertable({
      if (dietId != null) 'diet_id': dietId,
      if (eatingTime != null) 'eating_time': eatingTime,
      if (menuName != null) 'menu_name': menuName,
      if (amount != null) 'amount': amount,
      if (classfication != null) 'classfication': classfication,
      if (calories != null) 'calories': calories,
      if (carbohydrate != null) 'carbohydrate': carbohydrate,
      if (protein != null) 'protein': protein,
      if (fat != null) 'fat': fat,
      if (sodium != null) 'sodium': sodium,
      if (sugar != null) 'sugar': sugar,
    });
  }

  DietCompanion copyWith(
      {Value<int>? dietId,
      Value<DateTime>? eatingTime,
      Value<String>? menuName,
      Value<double>? amount,
      Value<int>? classfication,
      Value<double>? calories,
      Value<double>? carbohydrate,
      Value<double>? protein,
      Value<double>? fat,
      Value<double>? sodium,
      Value<double>? sugar}) {
    return DietCompanion(
      dietId: dietId ?? this.dietId,
      eatingTime: eatingTime ?? this.eatingTime,
      menuName: menuName ?? this.menuName,
      amount: amount ?? this.amount,
      classfication: classfication ?? this.classfication,
      calories: calories ?? this.calories,
      carbohydrate: carbohydrate ?? this.carbohydrate,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      sodium: sodium ?? this.sodium,
      sugar: sugar ?? this.sugar,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dietId.present) {
      map['diet_id'] = Variable<int>(dietId.value);
    }
    if (eatingTime.present) {
      map['eating_time'] = Variable<DateTime>(eatingTime.value);
    }
    if (menuName.present) {
      map['menu_name'] = Variable<String>(menuName.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (classfication.present) {
      map['classfication'] = Variable<int>(classfication.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (carbohydrate.present) {
      map['carbohydrate'] = Variable<double>(carbohydrate.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (sodium.present) {
      map['sodium'] = Variable<double>(sodium.value);
    }
    if (sugar.present) {
      map['sugar'] = Variable<double>(sugar.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DietCompanion(')
          ..write('dietId: $dietId, ')
          ..write('eatingTime: $eatingTime, ')
          ..write('menuName: $menuName, ')
          ..write('amount: $amount, ')
          ..write('classfication: $classfication, ')
          ..write('calories: $calories, ')
          ..write('carbohydrate: $carbohydrate, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('sodium: $sodium, ')
          ..write('sugar: $sugar')
          ..write(')'))
        .toString();
  }
}

class $PersonalSettingsTable extends PersonalSettings
    with TableInfo<$PersonalSettingsTable, PersonalSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nicknameMeta =
      const VerificationMeta('nickname');
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
      'nickname', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
      'height', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recommenedCaloriesMeta =
      const VerificationMeta('recommenedCalories');
  @override
  late final GeneratedColumn<double> recommenedCalories =
      GeneratedColumn<double>('recommened_calories', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _targetCaloriesMeta =
      const VerificationMeta('targetCalories');
  @override
  late final GeneratedColumn<double> targetCalories = GeneratedColumn<double>(
      'target_calories', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _targetWaterIntakeMeta =
      const VerificationMeta('targetWaterIntake');
  @override
  late final GeneratedColumn<double> targetWaterIntake =
      GeneratedColumn<double>('target_water_intake', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        nickname,
        height,
        weight,
        age,
        recommenedCalories,
        targetCalories,
        targetWaterIntake
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_settings';
  @override
  VerificationContext validateIntegrity(Insertable<PersonalSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('recommened_calories')) {
      context.handle(
          _recommenedCaloriesMeta,
          recommenedCalories.isAcceptableOrUnknown(
              data['recommened_calories']!, _recommenedCaloriesMeta));
    } else if (isInserting) {
      context.missing(_recommenedCaloriesMeta);
    }
    if (data.containsKey('target_calories')) {
      context.handle(
          _targetCaloriesMeta,
          targetCalories.isAcceptableOrUnknown(
              data['target_calories']!, _targetCaloriesMeta));
    } else if (isInserting) {
      context.missing(_targetCaloriesMeta);
    }
    if (data.containsKey('target_water_intake')) {
      context.handle(
          _targetWaterIntakeMeta,
          targetWaterIntake.isAcceptableOrUnknown(
              data['target_water_intake']!, _targetWaterIntakeMeta));
    } else if (isInserting) {
      context.missing(_targetWaterIntakeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  PersonalSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalSetting(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      nickname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nickname'])!,
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!,
      recommenedCalories: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}recommened_calories'])!,
      targetCalories: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}target_calories'])!,
      targetWaterIntake: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}target_water_intake'])!,
    );
  }

  @override
  $PersonalSettingsTable createAlias(String alias) {
    return $PersonalSettingsTable(attachedDatabase, alias);
  }
}

class PersonalSetting extends DataClass implements Insertable<PersonalSetting> {
  final String userId;
  final String nickname;
  final double height;
  final double weight;
  final int age;
  final double recommenedCalories;
  final double targetCalories;
  final double targetWaterIntake;
  const PersonalSetting(
      {required this.userId,
      required this.nickname,
      required this.height,
      required this.weight,
      required this.age,
      required this.recommenedCalories,
      required this.targetCalories,
      required this.targetWaterIntake});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['nickname'] = Variable<String>(nickname);
    map['height'] = Variable<double>(height);
    map['weight'] = Variable<double>(weight);
    map['age'] = Variable<int>(age);
    map['recommened_calories'] = Variable<double>(recommenedCalories);
    map['target_calories'] = Variable<double>(targetCalories);
    map['target_water_intake'] = Variable<double>(targetWaterIntake);
    return map;
  }

  PersonalSettingsCompanion toCompanion(bool nullToAbsent) {
    return PersonalSettingsCompanion(
      userId: Value(userId),
      nickname: Value(nickname),
      height: Value(height),
      weight: Value(weight),
      age: Value(age),
      recommenedCalories: Value(recommenedCalories),
      targetCalories: Value(targetCalories),
      targetWaterIntake: Value(targetWaterIntake),
    );
  }

  factory PersonalSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalSetting(
      userId: serializer.fromJson<String>(json['userId']),
      nickname: serializer.fromJson<String>(json['nickname']),
      height: serializer.fromJson<double>(json['height']),
      weight: serializer.fromJson<double>(json['weight']),
      age: serializer.fromJson<int>(json['age']),
      recommenedCalories:
          serializer.fromJson<double>(json['recommenedCalories']),
      targetCalories: serializer.fromJson<double>(json['targetCalories']),
      targetWaterIntake: serializer.fromJson<double>(json['targetWaterIntake']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'nickname': serializer.toJson<String>(nickname),
      'height': serializer.toJson<double>(height),
      'weight': serializer.toJson<double>(weight),
      'age': serializer.toJson<int>(age),
      'recommenedCalories': serializer.toJson<double>(recommenedCalories),
      'targetCalories': serializer.toJson<double>(targetCalories),
      'targetWaterIntake': serializer.toJson<double>(targetWaterIntake),
    };
  }

  PersonalSetting copyWith(
          {String? userId,
          String? nickname,
          double? height,
          double? weight,
          int? age,
          double? recommenedCalories,
          double? targetCalories,
          double? targetWaterIntake}) =>
      PersonalSetting(
        userId: userId ?? this.userId,
        nickname: nickname ?? this.nickname,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        age: age ?? this.age,
        recommenedCalories: recommenedCalories ?? this.recommenedCalories,
        targetCalories: targetCalories ?? this.targetCalories,
        targetWaterIntake: targetWaterIntake ?? this.targetWaterIntake,
      );
  @override
  String toString() {
    return (StringBuffer('PersonalSetting(')
          ..write('userId: $userId, ')
          ..write('nickname: $nickname, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('age: $age, ')
          ..write('recommenedCalories: $recommenedCalories, ')
          ..write('targetCalories: $targetCalories, ')
          ..write('targetWaterIntake: $targetWaterIntake')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, nickname, height, weight, age,
      recommenedCalories, targetCalories, targetWaterIntake);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalSetting &&
          other.userId == this.userId &&
          other.nickname == this.nickname &&
          other.height == this.height &&
          other.weight == this.weight &&
          other.age == this.age &&
          other.recommenedCalories == this.recommenedCalories &&
          other.targetCalories == this.targetCalories &&
          other.targetWaterIntake == this.targetWaterIntake);
}

class PersonalSettingsCompanion extends UpdateCompanion<PersonalSetting> {
  final Value<String> userId;
  final Value<String> nickname;
  final Value<double> height;
  final Value<double> weight;
  final Value<int> age;
  final Value<double> recommenedCalories;
  final Value<double> targetCalories;
  final Value<double> targetWaterIntake;
  final Value<int> rowid;
  const PersonalSettingsCompanion({
    this.userId = const Value.absent(),
    this.nickname = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.age = const Value.absent(),
    this.recommenedCalories = const Value.absent(),
    this.targetCalories = const Value.absent(),
    this.targetWaterIntake = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalSettingsCompanion.insert({
    required String userId,
    required String nickname,
    required double height,
    required double weight,
    required int age,
    required double recommenedCalories,
    required double targetCalories,
    required double targetWaterIntake,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        nickname = Value(nickname),
        height = Value(height),
        weight = Value(weight),
        age = Value(age),
        recommenedCalories = Value(recommenedCalories),
        targetCalories = Value(targetCalories),
        targetWaterIntake = Value(targetWaterIntake);
  static Insertable<PersonalSetting> custom({
    Expression<String>? userId,
    Expression<String>? nickname,
    Expression<double>? height,
    Expression<double>? weight,
    Expression<int>? age,
    Expression<double>? recommenedCalories,
    Expression<double>? targetCalories,
    Expression<double>? targetWaterIntake,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (nickname != null) 'nickname': nickname,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (age != null) 'age': age,
      if (recommenedCalories != null) 'recommened_calories': recommenedCalories,
      if (targetCalories != null) 'target_calories': targetCalories,
      if (targetWaterIntake != null) 'target_water_intake': targetWaterIntake,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalSettingsCompanion copyWith(
      {Value<String>? userId,
      Value<String>? nickname,
      Value<double>? height,
      Value<double>? weight,
      Value<int>? age,
      Value<double>? recommenedCalories,
      Value<double>? targetCalories,
      Value<double>? targetWaterIntake,
      Value<int>? rowid}) {
    return PersonalSettingsCompanion(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      recommenedCalories: recommenedCalories ?? this.recommenedCalories,
      targetCalories: targetCalories ?? this.targetCalories,
      targetWaterIntake: targetWaterIntake ?? this.targetWaterIntake,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (recommenedCalories.present) {
      map['recommened_calories'] = Variable<double>(recommenedCalories.value);
    }
    if (targetCalories.present) {
      map['target_calories'] = Variable<double>(targetCalories.value);
    }
    if (targetWaterIntake.present) {
      map['target_water_intake'] = Variable<double>(targetWaterIntake.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalSettingsCompanion(')
          ..write('userId: $userId, ')
          ..write('nickname: $nickname, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('age: $age, ')
          ..write('recommenedCalories: $recommenedCalories, ')
          ..write('targetCalories: $targetCalories, ')
          ..write('targetWaterIntake: $targetWaterIntake, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyActivityInfoTable extends DailyActivityInfo
    with TableInfo<$DailyActivityInfoTable, DailyActivityInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyActivityInfoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordDateMeta =
      const VerificationMeta('recordDate');
  @override
  late final GeneratedColumn<DateTime> recordDate = GeneratedColumn<DateTime>(
      'record_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalCalorieIntakeMeta =
      const VerificationMeta('totalCalorieIntake');
  @override
  late final GeneratedColumn<double> totalCalorieIntake =
      GeneratedColumn<double>('total_calorie_intake', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalCalorieBurnedMeta =
      const VerificationMeta('totalCalorieBurned');
  @override
  late final GeneratedColumn<double> totalCalorieBurned =
      GeneratedColumn<double>('total_calorie_burned', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _waterIntakeMeta =
      const VerificationMeta('waterIntake');
  @override
  late final GeneratedColumn<double> waterIntake = GeneratedColumn<double>(
      'water_intake', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [recordDate, totalCalorieIntake, totalCalorieBurned, waterIntake];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_activity_info';
  @override
  VerificationContext validateIntegrity(
      Insertable<DailyActivityInfoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('record_date')) {
      context.handle(
          _recordDateMeta,
          recordDate.isAcceptableOrUnknown(
              data['record_date']!, _recordDateMeta));
    } else if (isInserting) {
      context.missing(_recordDateMeta);
    }
    if (data.containsKey('total_calorie_intake')) {
      context.handle(
          _totalCalorieIntakeMeta,
          totalCalorieIntake.isAcceptableOrUnknown(
              data['total_calorie_intake']!, _totalCalorieIntakeMeta));
    } else if (isInserting) {
      context.missing(_totalCalorieIntakeMeta);
    }
    if (data.containsKey('total_calorie_burned')) {
      context.handle(
          _totalCalorieBurnedMeta,
          totalCalorieBurned.isAcceptableOrUnknown(
              data['total_calorie_burned']!, _totalCalorieBurnedMeta));
    } else if (isInserting) {
      context.missing(_totalCalorieBurnedMeta);
    }
    if (data.containsKey('water_intake')) {
      context.handle(
          _waterIntakeMeta,
          waterIntake.isAcceptableOrUnknown(
              data['water_intake']!, _waterIntakeMeta));
    } else if (isInserting) {
      context.missing(_waterIntakeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recordDate};
  @override
  DailyActivityInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyActivityInfoData(
      recordDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}record_date'])!,
      totalCalorieIntake: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_calorie_intake'])!,
      totalCalorieBurned: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_calorie_burned'])!,
      waterIntake: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}water_intake'])!,
    );
  }

  @override
  $DailyActivityInfoTable createAlias(String alias) {
    return $DailyActivityInfoTable(attachedDatabase, alias);
  }
}

class DailyActivityInfoData extends DataClass
    implements Insertable<DailyActivityInfoData> {
  final DateTime recordDate;
  final double totalCalorieIntake;
  final double totalCalorieBurned;
  final double waterIntake;
  const DailyActivityInfoData(
      {required this.recordDate,
      required this.totalCalorieIntake,
      required this.totalCalorieBurned,
      required this.waterIntake});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['record_date'] = Variable<DateTime>(recordDate);
    map['total_calorie_intake'] = Variable<double>(totalCalorieIntake);
    map['total_calorie_burned'] = Variable<double>(totalCalorieBurned);
    map['water_intake'] = Variable<double>(waterIntake);
    return map;
  }

  DailyActivityInfoCompanion toCompanion(bool nullToAbsent) {
    return DailyActivityInfoCompanion(
      recordDate: Value(recordDate),
      totalCalorieIntake: Value(totalCalorieIntake),
      totalCalorieBurned: Value(totalCalorieBurned),
      waterIntake: Value(waterIntake),
    );
  }

  factory DailyActivityInfoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyActivityInfoData(
      recordDate: serializer.fromJson<DateTime>(json['recordDate']),
      totalCalorieIntake:
          serializer.fromJson<double>(json['totalCalorieIntake']),
      totalCalorieBurned:
          serializer.fromJson<double>(json['totalCalorieBurned']),
      waterIntake: serializer.fromJson<double>(json['waterIntake']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recordDate': serializer.toJson<DateTime>(recordDate),
      'totalCalorieIntake': serializer.toJson<double>(totalCalorieIntake),
      'totalCalorieBurned': serializer.toJson<double>(totalCalorieBurned),
      'waterIntake': serializer.toJson<double>(waterIntake),
    };
  }

  DailyActivityInfoData copyWith(
          {DateTime? recordDate,
          double? totalCalorieIntake,
          double? totalCalorieBurned,
          double? waterIntake}) =>
      DailyActivityInfoData(
        recordDate: recordDate ?? this.recordDate,
        totalCalorieIntake: totalCalorieIntake ?? this.totalCalorieIntake,
        totalCalorieBurned: totalCalorieBurned ?? this.totalCalorieBurned,
        waterIntake: waterIntake ?? this.waterIntake,
      );
  @override
  String toString() {
    return (StringBuffer('DailyActivityInfoData(')
          ..write('recordDate: $recordDate, ')
          ..write('totalCalorieIntake: $totalCalorieIntake, ')
          ..write('totalCalorieBurned: $totalCalorieBurned, ')
          ..write('waterIntake: $waterIntake')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      recordDate, totalCalorieIntake, totalCalorieBurned, waterIntake);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyActivityInfoData &&
          other.recordDate == this.recordDate &&
          other.totalCalorieIntake == this.totalCalorieIntake &&
          other.totalCalorieBurned == this.totalCalorieBurned &&
          other.waterIntake == this.waterIntake);
}

class DailyActivityInfoCompanion
    extends UpdateCompanion<DailyActivityInfoData> {
  final Value<DateTime> recordDate;
  final Value<double> totalCalorieIntake;
  final Value<double> totalCalorieBurned;
  final Value<double> waterIntake;
  final Value<int> rowid;
  const DailyActivityInfoCompanion({
    this.recordDate = const Value.absent(),
    this.totalCalorieIntake = const Value.absent(),
    this.totalCalorieBurned = const Value.absent(),
    this.waterIntake = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyActivityInfoCompanion.insert({
    required DateTime recordDate,
    required double totalCalorieIntake,
    required double totalCalorieBurned,
    required double waterIntake,
    this.rowid = const Value.absent(),
  })  : recordDate = Value(recordDate),
        totalCalorieIntake = Value(totalCalorieIntake),
        totalCalorieBurned = Value(totalCalorieBurned),
        waterIntake = Value(waterIntake);
  static Insertable<DailyActivityInfoData> custom({
    Expression<DateTime>? recordDate,
    Expression<double>? totalCalorieIntake,
    Expression<double>? totalCalorieBurned,
    Expression<double>? waterIntake,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recordDate != null) 'record_date': recordDate,
      if (totalCalorieIntake != null)
        'total_calorie_intake': totalCalorieIntake,
      if (totalCalorieBurned != null)
        'total_calorie_burned': totalCalorieBurned,
      if (waterIntake != null) 'water_intake': waterIntake,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyActivityInfoCompanion copyWith(
      {Value<DateTime>? recordDate,
      Value<double>? totalCalorieIntake,
      Value<double>? totalCalorieBurned,
      Value<double>? waterIntake,
      Value<int>? rowid}) {
    return DailyActivityInfoCompanion(
      recordDate: recordDate ?? this.recordDate,
      totalCalorieIntake: totalCalorieIntake ?? this.totalCalorieIntake,
      totalCalorieBurned: totalCalorieBurned ?? this.totalCalorieBurned,
      waterIntake: waterIntake ?? this.waterIntake,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordDate.present) {
      map['record_date'] = Variable<DateTime>(recordDate.value);
    }
    if (totalCalorieIntake.present) {
      map['total_calorie_intake'] = Variable<double>(totalCalorieIntake.value);
    }
    if (totalCalorieBurned.present) {
      map['total_calorie_burned'] = Variable<double>(totalCalorieBurned.value);
    }
    if (waterIntake.present) {
      map['water_intake'] = Variable<double>(waterIntake.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityInfoCompanion(')
          ..write('recordDate: $recordDate, ')
          ..write('totalCalorieIntake: $totalCalorieIntake, ')
          ..write('totalCalorieBurned: $totalCalorieBurned, ')
          ..write('waterIntake: $waterIntake, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyActivityDetailTable extends DailyActivityDetail
    with TableInfo<$DailyActivityDetailTable, DailyActivityDetailData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyActivityDetailTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordDateMeta =
      const VerificationMeta('recordDate');
  @override
  late final GeneratedColumn<DateTime> recordDate = GeneratedColumn<DateTime>(
      'record_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _activityNameMeta =
      const VerificationMeta('activityName');
  @override
  late final GeneratedColumn<String> activityName = GeneratedColumn<String>(
      'activity_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _calorieBurnedMeta =
      const VerificationMeta('calorieBurned');
  @override
  late final GeneratedColumn<double> calorieBurned = GeneratedColumn<double>(
      'calorie_burned', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [recordDate, activityName, calorieBurned, startTime, endTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_activity_detail';
  @override
  VerificationContext validateIntegrity(
      Insertable<DailyActivityDetailData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('record_date')) {
      context.handle(
          _recordDateMeta,
          recordDate.isAcceptableOrUnknown(
              data['record_date']!, _recordDateMeta));
    } else if (isInserting) {
      context.missing(_recordDateMeta);
    }
    if (data.containsKey('activity_name')) {
      context.handle(
          _activityNameMeta,
          activityName.isAcceptableOrUnknown(
              data['activity_name']!, _activityNameMeta));
    } else if (isInserting) {
      context.missing(_activityNameMeta);
    }
    if (data.containsKey('calorie_burned')) {
      context.handle(
          _calorieBurnedMeta,
          calorieBurned.isAcceptableOrUnknown(
              data['calorie_burned']!, _calorieBurnedMeta));
    } else if (isInserting) {
      context.missing(_calorieBurnedMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recordDate};
  @override
  DailyActivityDetailData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyActivityDetailData(
      recordDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}record_date'])!,
      activityName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activity_name'])!,
      calorieBurned: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}calorie_burned'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time'])!,
    );
  }

  @override
  $DailyActivityDetailTable createAlias(String alias) {
    return $DailyActivityDetailTable(attachedDatabase, alias);
  }
}

class DailyActivityDetailData extends DataClass
    implements Insertable<DailyActivityDetailData> {
  final DateTime recordDate;
  final String activityName;
  final double calorieBurned;
  final DateTime startTime;
  final DateTime endTime;
  const DailyActivityDetailData(
      {required this.recordDate,
      required this.activityName,
      required this.calorieBurned,
      required this.startTime,
      required this.endTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['record_date'] = Variable<DateTime>(recordDate);
    map['activity_name'] = Variable<String>(activityName);
    map['calorie_burned'] = Variable<double>(calorieBurned);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    return map;
  }

  DailyActivityDetailCompanion toCompanion(bool nullToAbsent) {
    return DailyActivityDetailCompanion(
      recordDate: Value(recordDate),
      activityName: Value(activityName),
      calorieBurned: Value(calorieBurned),
      startTime: Value(startTime),
      endTime: Value(endTime),
    );
  }

  factory DailyActivityDetailData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyActivityDetailData(
      recordDate: serializer.fromJson<DateTime>(json['recordDate']),
      activityName: serializer.fromJson<String>(json['activityName']),
      calorieBurned: serializer.fromJson<double>(json['calorieBurned']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recordDate': serializer.toJson<DateTime>(recordDate),
      'activityName': serializer.toJson<String>(activityName),
      'calorieBurned': serializer.toJson<double>(calorieBurned),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
    };
  }

  DailyActivityDetailData copyWith(
          {DateTime? recordDate,
          String? activityName,
          double? calorieBurned,
          DateTime? startTime,
          DateTime? endTime}) =>
      DailyActivityDetailData(
        recordDate: recordDate ?? this.recordDate,
        activityName: activityName ?? this.activityName,
        calorieBurned: calorieBurned ?? this.calorieBurned,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
      );
  @override
  String toString() {
    return (StringBuffer('DailyActivityDetailData(')
          ..write('recordDate: $recordDate, ')
          ..write('activityName: $activityName, ')
          ..write('calorieBurned: $calorieBurned, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(recordDate, activityName, calorieBurned, startTime, endTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyActivityDetailData &&
          other.recordDate == this.recordDate &&
          other.activityName == this.activityName &&
          other.calorieBurned == this.calorieBurned &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime);
}

class DailyActivityDetailCompanion
    extends UpdateCompanion<DailyActivityDetailData> {
  final Value<DateTime> recordDate;
  final Value<String> activityName;
  final Value<double> calorieBurned;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> rowid;
  const DailyActivityDetailCompanion({
    this.recordDate = const Value.absent(),
    this.activityName = const Value.absent(),
    this.calorieBurned = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyActivityDetailCompanion.insert({
    required DateTime recordDate,
    required String activityName,
    required double calorieBurned,
    required DateTime startTime,
    required DateTime endTime,
    this.rowid = const Value.absent(),
  })  : recordDate = Value(recordDate),
        activityName = Value(activityName),
        calorieBurned = Value(calorieBurned),
        startTime = Value(startTime),
        endTime = Value(endTime);
  static Insertable<DailyActivityDetailData> custom({
    Expression<DateTime>? recordDate,
    Expression<String>? activityName,
    Expression<double>? calorieBurned,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recordDate != null) 'record_date': recordDate,
      if (activityName != null) 'activity_name': activityName,
      if (calorieBurned != null) 'calorie_burned': calorieBurned,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyActivityDetailCompanion copyWith(
      {Value<DateTime>? recordDate,
      Value<String>? activityName,
      Value<double>? calorieBurned,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<int>? rowid}) {
    return DailyActivityDetailCompanion(
      recordDate: recordDate ?? this.recordDate,
      activityName: activityName ?? this.activityName,
      calorieBurned: calorieBurned ?? this.calorieBurned,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordDate.present) {
      map['record_date'] = Variable<DateTime>(recordDate.value);
    }
    if (activityName.present) {
      map['activity_name'] = Variable<String>(activityName.value);
    }
    if (calorieBurned.present) {
      map['calorie_burned'] = Variable<double>(calorieBurned.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityDetailCompanion(')
          ..write('recordDate: $recordDate, ')
          ..write('activityName: $activityName, ')
          ..write('calorieBurned: $calorieBurned, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ConfigDatabase extends GeneratedDatabase {
  _$ConfigDatabase(QueryExecutor e) : super(e);
  late final $DietTable diet = $DietTable(this);
  late final $PersonalSettingsTable personalSettings =
      $PersonalSettingsTable(this);
  late final $DailyActivityInfoTable dailyActivityInfo =
      $DailyActivityInfoTable(this);
  late final $DailyActivityDetailTable dailyActivityDetail =
      $DailyActivityDetailTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [diet, personalSettings, dailyActivityInfo, dailyActivityDetail];
}
