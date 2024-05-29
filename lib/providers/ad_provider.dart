import 'package:flutter/material.dart';
import 'package:bodyguard/model/ad_model.dart';
import 'package:bodyguard/services/ad_service.dart';

class AdProvider extends ChangeNotifier {
  final AdService adService = AdService();
  List<Ad> _ads = [];

  List<Ad> get ads => _ads;

  Future<void> fetchAds() async {
    try {
      _ads = await adService.fetchAds();
      notifyListeners();
    } catch (e) {
      // 오류 처리
    }
  }
}
