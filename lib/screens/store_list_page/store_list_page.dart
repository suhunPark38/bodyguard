import 'package:bodyguard/model/store_menu.dart';
import 'package:bodyguard/providers/shopping_provider.dart';
import 'package:flutter/material.dart';
import 'package:bodyguard/model/store_model.dart';
import 'package:provider/provider.dart';
import '../../services/store_service.dart';
import '../../widgets/nutrient_info_button.dart';

class StoreListPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context)
    {
      return Consumer<ShoppingProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('가게 목록'),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);

                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              body: StreamBuilder<List<Store>>(
                stream: StoreService().getStores(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Store> stores = snapshot.data!;

                  return ListView.builder(
                    itemCount: stores.length,
                    itemBuilder: (context, index) {
                      Store store = stores[index];
                      return ListTile(
                        title: Text(
                            "가게 이름: ${store.storeName}, 가게 소개: ${store
                                .subscript}"),
                        onTap: () {
                          _showMenuDialog(context, store);
                        },
                      );
                    },
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.shopping_cart),
              ),
            );
          });
    });
  }

  void _showMenuDialog(BuildContext context, Store store) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ShoppingProvider>(
          builder: (context, provider, child) {
            return AlertDialog(
              title: Text('${store.storeName} 메뉴'),
              content: SizedBox(
                height: 500, // 적절한 높이 지정
                width: double.maxFinite,
                child: StreamBuilder<List<StoreMenu>>(
                  stream: StoreService().getStoreMenu(store.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<StoreMenu> menuList = snapshot.data!;
                    return ListView.builder(
                      itemCount: menuList.length,
                      itemBuilder: (context, index) {
                        StoreMenu menu = menuList[index];
                        bool isSelected = provider.selectedMenus.contains(menu);
                        return CheckboxListTile(
                          secondary: NutrientInfoButton(size: 20, menu: menu,),
                          title: Text(menu.menuName),
                          subtitle: Text('가격: ${menu.price}'),
                          value: isSelected,
                          onChanged: (newValue) {
                              if (newValue!) {
                                Provider.of<ShoppingProvider>(
                                    context, listen: false).addMenu(
                                    store.id, menu, 1);
                              } else {
                                Provider.of<ShoppingProvider>(
                                    context, listen: false).removeMenu(menu);
                              }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('닫기'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
