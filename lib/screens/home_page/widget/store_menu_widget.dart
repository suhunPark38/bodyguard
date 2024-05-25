import 'dart:math';
import 'package:flutter/material.dart';
import '../../../model/store_menu.dart';
import '../../../model/store_model.dart';
import '../../../services/store_service.dart';
import '../../store_menu_page/store_menu_page.dart';
import 'food_info_widget.dart';

class StoreMenuWidget extends StatefulWidget {
  const StoreMenuWidget({super.key});

  @override
  _StoreMenuWidget createState() => _StoreMenuWidget();
}

class _StoreMenuWidget extends State<StoreMenuWidget> {
  Store? selectedStore;
  StoreMenu? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // 이 시점에서는 StreamBuilder로 처리하므로 onTap은 빈 함수로 남겨두었습니다.
      },
      child: StreamBuilder<List<Store>>(
        stream: StoreService().getStores(),
        builder: (context, storeSnapshot) {
          if (storeSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (storeSnapshot.hasError) {
            return Center(child: Text('가게 정보를 불러오지 못했습니다.'));
          } else if (!storeSnapshot.hasData || storeSnapshot.data!.isEmpty) {
            return Center(child: Text('가게 정보가 없습니다.'));
          } else {
            // 랜덤 가게 선택
            selectedStore = storeSnapshot.data![Random().nextInt(storeSnapshot.data!.length)];

            return StreamBuilder<List<StoreMenu>>(
              stream: StoreService().getStoreMenu(selectedStore!.id),
              builder: (context, menuSnapshot) {
                if (menuSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (menuSnapshot.hasError) {
                  return Center(child: Text('메뉴 정보를 불러오지 못했습니다.'));
                } else if (!menuSnapshot.hasData || menuSnapshot.data!.isEmpty) {
                  return Center(child: Text('메뉴 정보가 없습니다.'));
                } else {
                  // 랜덤 메뉴 선택
                  selectedMenu = menuSnapshot.data![Random().nextInt(menuSnapshot.data!.length)];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreMenuPage(store: selectedStore!),
                        ),
                      );
                    },
                    child: FoodInfoWidget(
                      storeId: selectedStore!.id,
                      foodId: selectedMenu!.id,
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
