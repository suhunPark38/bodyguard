// StoreMenuWidget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/store_service.dart';
import '../../../model/store_model.dart';
import '../../store_menu_page/store_menu_page.dart';
import 'food_info_widget.dart';

class StoreMenuWidget extends StatelessWidget {

  final String foodId;
  final String storeId;
  final StoreService storeService; // storeService 추가

  const StoreMenuWidget({Key? key, required this.storeId,  required this.foodId, required this.storeService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var store = await storeService.getStoreById(storeId);
        if (store != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreMenuPage(store: store),
            ),
          );
        } else {
          // 해당 ID의 가게가 없는 경우에 대한 처리
        }
      },

      child: FoodInfoWidget(storeId: storeId, foodId: foodId,storeService: storeService),

    );
  }
}
