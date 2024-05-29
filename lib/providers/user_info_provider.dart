import 'dart:async';
import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../services/user_firebase.dart';

class UserInfoProvider with ChangeNotifier{
  UserInfoModel? _user;
  StreamSubscription? _userSubscription;

  UserInfoModel? get info => _user;
  set height(double value){
    UserFirebase().updateHeight(value);
  }
  set weight(double value){
    UserFirebase().updateWeight(value);
  }


  void setUser(UserInfoModel user, BuildContext context) {
    _user = user;

    Provider.of<HealthDataProvider>(context, listen: false).updateHeight(_user?.height);
    Provider.of<HealthDataProvider>(context, listen: false).updateWeight(_user?.weight);
    Provider.of<HealthDataProvider>(context, listen: false).updateTargetCalorie(_user?.targetCalorie);
    notifyListeners();
  }
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }

  void fetchUser(String userId, BuildContext context) {
    _userSubscription?.cancel(); // 기존 구독이 있다면 취소합니다.
    _userSubscription = UserFirebase().fetchUser(userId).listen((snapshot) {
      setUser(UserInfoModel.fromJson(snapshot), context);
    });
  }




  @override
  void dispose() {
    _userSubscription?.cancel(); // 위젯이 dispose될 때 스트림 구독을 취소합니다.
    super.dispose();
  }
}

