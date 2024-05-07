import 'package:auto_size_text/auto_size_text.dart';
import 'package:bodyguard/model/store_menu.dart';
import 'package:bodyguard/providers/shopping_provider.dart';
import 'package:flutter/material.dart';
import 'package:bodyguard/model/store_model.dart';
import 'package:provider/provider.dart';
import '../../services/store_service.dart';
import '../../widgets/nutrient_info_button.dart';
import '../shopping_page/shopping_page.dart';


class StoreListPage extends StatelessWidget  {


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
                        leading: Image.network(stores[index].image, width: 100, height: 100, fit: BoxFit.fill),
                        title: AutoSizeText(
                          "가게 이름: ${stores[index].storeName}",
                          maxLines: 1,
                        ),
                        subtitle: AutoSizeText(
                          "가게 설명: ${stores[index].subscript}",
                          maxLines: 1,
                        ),
                        trailing: Text("${stores[index].cuisineType}"),
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
                  Provider.of<ShoppingProvider>(context, listen: false).setCurrentTabIndex(0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShoppingPage(),
                    ),
                  );
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
                          contentPadding: EdgeInsets.all(5.0),

                          secondary: Row(
                            mainAxisSize: MainAxisSize.min, // Row 크기를 최소로 제한
                            children: <Widget>[
                              // 메뉴 이미지
                              Image.network(
                                menu.image, // 메뉴 이미지 URL
                                width: 70, // 이미지 폭
                                height: 70, // 이미지 높이
                                fit: BoxFit.fitWidth, // 이미지 채우기 모드
                              ),
                              IconButton(
                                icon: const Icon(Icons.info),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('${menu.menuName} - 영양성분'),
                                        content: Text(
                                            '칼로리: ${menu.calories},'
                                                ' 탄수화물: ${menu.carbohydrate},'
                                                ' 지방: ${menu.fat},'
                                                ' 단백질: ${menu.protein},'
                                                ' 나트륨: ${menu.sodium},'
                                                ' 당: ${menu.sugar}'
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          title: AutoSizeText(
                            "${menu.menuName}",
                            maxLines: 1,
                          ),
                          subtitle: AutoSizeText(
                            "가격: ${menu.price}",
                            maxLines: 1,
                          ),
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
