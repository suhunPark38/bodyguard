import 'package:flutter/material.dart';
import '../../../model/store_menu.dart';
import '../../../model/store_model.dart';
import '../../../services/store_service.dart';
import '../../store_menu_page/store_menu_page.dart';

class StoreMenuWidget extends StatelessWidget {
  const StoreMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Store>>(
      stream: StoreService().getStores(),
      builder: (context, storeSnapshot) {
        if (storeSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (storeSnapshot.hasError) {
          return Center(child: Text('가게 정보를 불러오지 못했습니다.'));
        } else if (!storeSnapshot.hasData || storeSnapshot.data!.isEmpty) {
          return Center(child: Text('가게 정보가 없습니다.'));
        } else {
          return ListView.builder(
            itemCount: storeSnapshot.data!.length,
            itemBuilder: (context, index) {
              Store store = storeSnapshot.data![index];
              return StreamBuilder<List<StoreMenu>>(
                stream: StoreService().getStoreMenu(store.id),
                builder: (context, menuSnapshot) {
                  if (menuSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (menuSnapshot.hasError) {
                    return Center(child: Text('메뉴 정보를 불러오지 못했습니다.'));
                  } else if (!menuSnapshot.hasData || menuSnapshot.data!.isEmpty) {
                    return Center(child: Text('메뉴 정보가 없습니다.'));
                  } else {
                    return ExpansionTile(
                      title: Text(store.storeName),
                      children: menuSnapshot.data!
                          .map((menu) => ListTile(
                        title: Text(menu.menuName),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreMenuPage(store: store),
                            ),
                          );
                        },
                      ))
                          .toList(),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
