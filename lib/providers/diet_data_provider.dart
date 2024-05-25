import 'package:flutter/material.dart';
import 'package:bodyguard/model/fetched_diet_data.dart';
import 'package:bodyguard/utils/diet_util.dart';

class DietDataProvider extends ChangeNotifier {
  List<FetchedDietData> _dietDataList = [];
  double _amount = 1.0;
  DateTime _eatingTime = DateTime.now();
  int _classification = 0;

  List<FetchedDietData> get dietDataList => _dietDataList;
  double get amount => _amount;
  DateTime get eatingTime => _eatingTime;
  int get classification => _classification;

  Future<void> fetchDietData(String searchTerm) async {
    _dietDataList.clear();
    _dietDataList = await DietUtil().Fetchinfo(searchTerm);
    notifyListeners();
  }
  void resetData(){
    _dietDataList = [];
    _amount = 1.0;
   _eatingTime = DateTime.now();
    _classification = 0;
    notifyListeners();
  }

  void setAmount(double newAmount) {
    _amount = newAmount;
    notifyListeners();
  }

  void setEatingTime(DateTime newEatingTime) {
    _eatingTime = newEatingTime;
    notifyListeners();
  }

  void setClassification(int newClassification) {
    _classification = newClassification;
    notifyListeners();
  }

  void clearDietData() {
    _dietDataList = [];
    notifyListeners();
  }
}
