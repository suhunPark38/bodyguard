import 'package:flutter/material.dart';
import 'package:bodyguard/model/store_menu.dart';
import 'package:bodyguard/database/shopping_cart_database.dart';

class ShoppingCartProvider extends ChangeNotifier {
  List<StoreMenu> _selectedMenus = [];
  List<StoreMenu> get selectedMenus => _selectedMenus;

  void addMenu(StoreMenu menu, int quantity) {
    _selectedMenus.add(menu);
    notifyListeners();
    ShoppingCartDatabase.instance.insertMenu(menu, quantity);
  }

  void removeMenu(StoreMenu menu) {
    _selectedMenus.remove(menu);
    notifyListeners();
    ShoppingCartDatabase.instance.removeMenu(menu);
  }

  Future<void> loadSelectedMenus() async {
    final selectedMenus = await ShoppingCartDatabase.instance.getSelectedMenus();
    _selectedMenus.clear();
    for (final menuMap in selectedMenus) {
      final menuId = menuMap['menu_id'] as String;
      final quantity = menuMap['quantity'] as int;
      final menu = await ShoppingCartDatabase.instance.getMenuById(menuId);
      if (menu != null) {
        for (int i = 0; i < quantity; i++) {
          _selectedMenus.add(menu);
        }
      }
    }
    notifyListeners();
  }
}
