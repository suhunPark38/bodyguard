import 'package:flutter/material.dart';
import 'package:bodyguard/model/store_menu.dart';
import 'package:bodyguard/database/shopping_database.dart';
import 'package:uuid/uuid.dart';

import '../model/payment.dart';
import '../services/payment_service.dart';
import '../services/store_service.dart';

class ShoppingProvider extends ChangeNotifier {
  List<StoreMenu> _selectedMenus = [];
  String? _deliveryType;
  int _totalPrice = 0;
  int _currentTabIndex = 0;

  final Map<String, List<StoreMenu>> _storeMenuMap = {};
  final Map<StoreMenu, int> _menuQuantities = {};

  List<Payment> _cachedPayments = [];

  List<StoreMenu> get selectedMenus => _selectedMenus;

  String? get deliveryType => _deliveryType;

  int get totalPrice => _totalPrice;

  int get currentTabIndex => _currentTabIndex;

  Map<String, List<StoreMenu>> get storeMenuMap => _storeMenuMap;

  Map<StoreMenu, int> get menuQuantities => _menuQuantities;

  ShoppingProvider() {
    _initializeData();
  }

  // 데이터 초기화를 위한 비동기 함수
  Future<void> _initializeData() async {
    await loadSelectedMenus();
  }

  void setCurrentTabIndex(int value) {
    _currentTabIndex = value;
    notifyListeners();
    print("현재탭$_currentTabIndex");
  }

  void setSelectedMenus(List<StoreMenu> value) {
    _selectedMenus = value;
    notifyListeners();
  }

  void calculateTotalPrice() {
    int totalPrice = 0;
    for (var menu in _selectedMenus) {
      totalPrice += (menu.price * _menuQuantities[menu]!);
    }
    _totalPrice = totalPrice;
    notifyListeners();
  }

  void handleDeliveryTypeChange(String? value) {
    _deliveryType = value;
    notifyListeners();
  }

  Future<void> completePayment() async {
    final payment = Payment(
      orderId: const Uuid().v4(),
      currency: 'KRW',
      status: PaymentStatus.completed,
      timestamp: DateTime.now(),
      totalPrice: _totalPrice,
      menus: _selectedMenus,
      deliveryType: _deliveryType!,
    );

    try {
      await PaymentService().addPayment(payment);
    } catch (e) {}
  }

  void handleReset() {
    _selectedMenus.clear();
    _storeMenuMap.clear();
    _menuQuantities.clear();
    _deliveryType = null;
    _totalPrice = 0;
    ShoppingDatabase.clearData();
    notifyListeners();
  }
  void updateMenuQuantity(String menuId, int newQuantity) {
    for (var menu in _selectedMenus) {
      if (menu.id == menuId) {
        _menuQuantities[menu] = newQuantity;
        break;
      }
    }
    ShoppingDatabase.instance.updateMenuQuantity(menuId, newQuantity);
    notifyListeners();
  }



  Future<List<Payment>> fetchPayments({bool forceRefresh = false}) async {
    if (_cachedPayments.isEmpty || forceRefresh) {
      try {
        List<Payment> payments = await PaymentService().getPayments();
        _cachedPayments = payments;
        return payments;
      } catch (e) {
        print('결제 내역을 가져오는 중 오류가 발생했습니다: $e');
        return [];
      }
    } else {
      return _cachedPayments;
    }
  }
  void refreshPayments() {
    fetchPayments(forceRefresh: true);
  }


  void addMenu(String storeId, StoreMenu menu, int quantity) {
    _selectedMenus.add(menu);
    _menuQuantities[menu] = quantity; // 해당 메뉴의 수량 설정
    _storeMenuMap
        .putIfAbsent(menu.storeName, () => [])
        .add(menu); // 스토어 메뉴 맵에 추가
    ShoppingDatabase.instance.insertMenu(storeId, menu.id, quantity);
    calculateTotalPrice();
  }

  void removeMenu(StoreMenu menu) {
    _selectedMenus.remove(menu);

    if (_storeMenuMap.containsKey(menu.storeName)) {
      _storeMenuMap[menu.storeName]!.remove(menu);
      if (_storeMenuMap[menu.storeName]!.isEmpty) {
        _storeMenuMap.remove(menu.storeName);
      }
    }
    ShoppingDatabase.instance.removeMenu(menu.id);
    calculateTotalPrice();
  }

  Future<void> loadSelectedMenus() async {
    final selectedMenus =
        await ShoppingDatabase.instance.getSelectedMenus();
    _selectedMenus.clear();
    _menuQuantities.clear(); // 불러오기 전에 기존 데이터 초기화
    _storeMenuMap.clear(); // 스토어 메뉴 맵도 초기화

    for (final menuMap in selectedMenus) {
      final menuId = menuMap['menu_id'] as String;
      final storeId = menuMap['store_id'] as String;
      final quantity = menuMap['quantity'] as int;

      final menu = await StoreService().getMenuById(storeId, menuId);

      if (menu != null) {
        _selectedMenus.add(menu); // 선택한 메뉴에 추가
        _menuQuantities[menu] = quantity; // 해당 메뉴의 수량 설정
        _storeMenuMap
            .putIfAbsent(menu.storeName, () => [])
            .add(menu); // 스토어 메뉴 맵에 추가
      }
    }
    calculateTotalPrice();
  }
}
