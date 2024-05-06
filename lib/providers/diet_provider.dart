import 'package:flutter/cupertino.dart';

import '../database/config_database.dart';
import '../model/diet_record.dart';
import '../utils/calculate_util.dart';

class DietProvider with ChangeNotifier {

  final ConfigDatabase configDatabase = ConfigDatabase();

  List<DietData> _diets = [];
  List<DietData> _breakfast = [];
  List<DietData> _lunch =[];
  List<DietData> _dinner =[];
  DietRecord _totalNutritionalInfo = DietRecord(calories: 0, carbohydrates: 0, protein: 0, fat: 0, sodium: 0, sugar: 0);
  DateTime _eatingTime = DateTime.now();

  bool _disposed = false;


  List<DietData> get diets => _diets;
  List<DietData> get breakfast => _breakfast;
  List<DietData> get lunch => _lunch;
  List<DietData> get dinner => _dinner;
  DietRecord get totalNutritionalInfo => _totalNutritionalInfo;

  DietProvider(){
    _updateDietsList(_eatingTime);
  }


 @override
 void dispose() {
   _disposed = true;
   super.dispose();
 }

  @override
  void notifyListeners() {
    if(!_disposed) {
      super.notifyListeners();
    }
  }

  void notifySelectDiets(DateTime eatingTime) async {
    _eatingTime = eatingTime;
    _updateDietsList(_eatingTime);
  }

  void notifyInsertDiet(DietCompanion dietCompanion) {
    configDatabase.insertDiet(dietCompanion);
    _updateDietsList(_eatingTime);
  }

  void notifyDeleteDiet(int dietId) {
    configDatabase.deleteDiet(dietId);
    _updateDietsList(_eatingTime);
  }

  void notifyUpdateDiet(DietCompanion dietCompanion) {
    configDatabase.updateDiet(dietCompanion, dietCompanion.dietId.value);
    _updateDietsList(_eatingTime);
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

    notifyListeners();

  }

}


