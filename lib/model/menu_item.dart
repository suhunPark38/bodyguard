import 'package:bodyguard/model/store_menu.dart';

class MenuItem {
  final StoreMenu menu; // 메뉴 정보
  final int quantity; // 해당 메뉴의 개수

  MenuItem({
    required this.menu,
    required this.quantity,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      menu: StoreMenu.fromJson(json['menu']['id'], json['menu']),
      quantity: json['quantity'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'menu': menu.toJson(),
      'quantity': quantity,
    };
  }
}
