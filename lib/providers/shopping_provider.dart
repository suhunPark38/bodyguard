import 'package:flutter/material.dart';
import 'package:bodyguard/model/store_menu.dart';
import 'package:bodyguard/database/shopping_database.dart';
import 'package:uuid/uuid.dart';
import '../model/payment.dart';
import '../services/payment_service.dart';
import '../services/store_service.dart';

class ShoppingProvider extends ChangeNotifier {
  List<StoreMenu> _selectedMenus = []; //선택된 메뉴들
  String? _deliveryType; // 배달 종류 배달 혹은 포장
  int _totalPrice = 0; // 총가격
  int _currentTabIndex = 0; // 쇼핑 페이지 현재 탭

  final Map<String, List<StoreMenu>> _storeMenuMap = {}; //가게와 메뉴의 맵핑
  final Map<StoreMenu, int> _menuQuantities = {}; // 메뉴와 수량의 맵핑

  List<Payment> _payments = []; //결제 내역
  DateTime _selectedStartDate = DateTime(2024);
  DateTime _selectedEndDate = DateTime.now();

  List<StoreMenu> get selectedMenus => _selectedMenus;

  String? get deliveryType => _deliveryType;

  int get totalPrice => _totalPrice;

  int get currentTabIndex => _currentTabIndex;

  Map<String, List<StoreMenu>> get storeMenuMap => _storeMenuMap;

  Map<StoreMenu, int> get menuQuantities => _menuQuantities;

  List<Payment> get payments => _payments;

  DateTime get selectedStartDate => _selectedStartDate;
  DateTime get selectedEndDate => _selectedEndDate;

  ShoppingProvider() {
    _initializeData();
  }


  // 데이터 초기화를 위한 비동기 함수
  Future<void> _initializeData() async {
    await loadSelectedMenus();
    await fetchPayments();
  }

  void setCurrentTabIndex(int value) {
    _currentTabIndex = value;
    notifyListeners();
  }

  void setSelectedMenus(List<StoreMenu> value) {
    _selectedMenus = value;
    notifyListeners();
  }

  void setStartDate(DateTime startDate) {
    _selectedStartDate = startDate;
    notifyListeners();
  }

  void setEndDate(DateTime endDate) {
    _selectedEndDate = endDate;
    notifyListeners();
  }

  // 배달 종류 핸들러 함수
  void handleDeliveryTypeChange(String? value) {
    _deliveryType = value;
    notifyListeners();
  }

  // 주문 옵션 초기화 함수
  void handleReset() {
    _selectedMenus.clear();
    _storeMenuMap.clear();
    _menuQuantities.clear();
    _deliveryType = null;
    _totalPrice = 0;
    ShoppingDatabase.clearData();
    notifyListeners();
  }

  //총 가격 계산 함수
  void calculateTotalPrice() {
    int totalPrice = 0;
    for (var menu in _selectedMenus) {
      totalPrice += (menu.price * _menuQuantities[menu]!);
    }
    _totalPrice = totalPrice;
    notifyListeners();
  }

  //메뉴 수량 업데이트 함수
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

  //장바구니에 메뉴 추가 함수
  void addMenu(String storeId, StoreMenu menu, int quantity) {
    _selectedMenus.add(menu);
    _menuQuantities[menu] = quantity; // 해당 메뉴의 수량 설정
    _storeMenuMap
        .putIfAbsent(menu.storeName, () => [])
        .add(menu); // 스토어 메뉴 맵에 추가
    ShoppingDatabase.instance.insertMenu(storeId, menu.id, quantity);
    calculateTotalPrice();
  }

  //장바구니에 메뉴 삭제 함수
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

  //데이터베이스에서 메뉴를 불러오는 함수(장바구니 기능)
  Future<void> loadSelectedMenus() async {
    final selectedMenus = await ShoppingDatabase.instance.getSelectedMenus();
    _selectedMenus.clear(); // 선택된 메뉴 초기화
    _menuQuantities.clear(); // 불러오기 전에 기존 데이터 초기화
    _storeMenuMap.clear(); // 스토어 메뉴 맵 초기화

    for (final menuMap in selectedMenus) {
      final menuId = menuMap['menu_id'] as String;
      final storeId = menuMap['store_id'] as String;
      final quantity = menuMap['quantity'] as int;

      final menu =
          await StoreService().getMenuById(storeId, menuId); //파이어베이스에서 메뉴를 불러옴

      if (menu != null) {
        //있는 메뉴인지 확인
        _selectedMenus.add(menu); // 선택한 메뉴에 추가
        _menuQuantities[menu] = quantity; // 해당 메뉴의 수량 설정
        _storeMenuMap
            .putIfAbsent(menu.storeName, () => [])
            .add(menu); // 스토어 메뉴 맵에 추가
      }
    }
    calculateTotalPrice();
  }

  //결제 내역 추가 함수
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

  //결제 내역 불러오기 함수
  Future<void> fetchPayments({bool forceRefresh = false}) async {
    if (_payments.isEmpty || forceRefresh) {
      try {
        List<Payment> payments = await PaymentService().getPayments();
        _payments = payments;
      } catch (e) {
        print('결제 내역을 가져오는 중 오류가 발생했습니다: $e');
      }
    }
    notifyListeners();
  }

  //결제 내역 새로고침 함수
  void refreshPayments() {
    fetchPayments(forceRefresh: true);
  }


  // 선택한 기간에 해당하는 결제 내역을 필터링하는 함수
  List<Payment> filterPaymentsByDate(DateTime startDate, DateTime endDate) {
    final filteredPayments = _payments.where((payment) {
      // 선택한 날짜의 시간 부분을 00:00:00으로 설정하여 필터링
      final paymentDate = DateTime(payment.timestamp.year, payment.timestamp.month, payment.timestamp.day);
      return paymentDate.isAfter(startDate.subtract(const Duration(days: 1))) && paymentDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
    return filteredPayments;
  }



  // 정렬 및 필터링된 결제 내역을 반환하는 함수
  List<Payment> get sortedAndFilteredPayments {
    List<Payment> payments = filterPaymentsByDate(_selectedStartDate, _selectedEndDate);
    payments.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // 시간 역순으로 정렬
    return payments;

  }

}
