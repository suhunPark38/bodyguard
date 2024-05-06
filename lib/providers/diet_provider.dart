import 'package:flutter/cupertino.dart';

import '../database/config_database.dart';
import '../model/diet_record.dart';
import '../utils/calculate_util.dart';

class DietProvider with ChangeNotifier {

  final ConfigDatabase configDatabase = ConfigDatabase();

  List<DietData> _diets = [];
  List<DietData> _breakfast = [];
  List<DietData> _lunch = [];
  List<DietData> _dinner = [];
  DietRecord _totalNutritionalInfo = DietRecord(
      calories: 0.0,
      carbohydrates: 0.0,
      protein: 0.0,
      fat: 0.0,
      sodium: 0.0,
      sugar: 0.0
  );
  DateTime _eatingTime = DateTime.now();


  List<DietData> get diets => _diets;
  List<DietData> get breakfast => _breakfast;
  List<DietData> get lunch => _lunch;
  List<DietData> get dinner => _dinner;
  DietRecord get totalNutritionalInfo => _totalNutritionalInfo;

  void notifySelectDiets(DateTime eatingTime) async {
    _eatingTime = eatingTime;
    _diets = await configDatabase.getDietByEatingTime(_eatingTime);
    _updateDietsList(_eatingTime);
    notifyListeners();
  }

  void notifyInsertDiet(DietCompanion dietCompanion) {
    configDatabase.insertDiet(dietCompanion);
    _updateDietsList(_eatingTime);
    notifyListeners();
  }

  void notifyDeleteDiet(int dietId) {
    configDatabase.deleteDiet(dietId);
    _updateDietsList(_eatingTime);
    notifyListeners();
  }

  void notifyUpdateDiet(DietCompanion dietCompanion) {
    configDatabase.updateDiet(dietCompanion, dietCompanion.dietId.value);
    _updateDietsList(_eatingTime);
    notifyListeners();
  }





  void _updateDietsList(DateTime eatingTime) async {
    _diets = await configDatabase.getDietByEatingTime(eatingTime);

    _breakfast = _diets.where((diet) => diet.classification == 0).toList();
    _lunch = _diets.where((diet) => diet.classification == 1).toList();
    _dinner = _diets.where((diet) => diet.classification == 2).toList();

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

  }

}


