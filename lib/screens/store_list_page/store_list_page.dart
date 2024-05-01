import 'package:bodyguard/model/storeMenu.dart';
import 'package:flutter/material.dart';
import 'package:bodyguard/model/storeModel.dart';
import '../../services/store_service.dart';
import '../shopping_page/shopping_page.dart';

class StoreListPage extends StatefulWidget {
  final List<StoreMenu>? selectedMenus;

  const StoreListPage({Key? key, required this.selectedMenus})
      : super(key: key);

  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  List<StoreMenu> _selectedMenus = [];

  @override
  void initState() {
    super.initState();
    _selectedMenus = widget.selectedMenus ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가게 목록'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context,_selectedMenus);
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
                    "가게 이름: ${store.StoreName}, 가게 소개: ${store.subscript}"),
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
          Navigator.pop(context, _selectedMenus);
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  void _showMenuDialog(BuildContext context, Store store) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('${store.StoreName} 메뉴'),
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
                        bool isSelected = _selectedMenus.contains(menu);
                        return CheckboxListTile(
                          secondary:IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        '${menu.menuName} - 영양성분'),
                                    content: Text(
                                        '칼로리: ${menu.calories},'
                                            ' 탄수화물: ${menu.carbohydrate},'
                                            ' 지방: ${menu.fat},'
                                            ' 단백질: ${menu.protein},'
                                            ' 나트륨: ${menu.sodium},'
                                            ' 당: ${menu.sugar}'),
                                  );
                                },
                              );
                            },
                          ),
                          title: Text(menu.menuName),
                          subtitle: Text('가격: ${menu.price}'),
                          value: isSelected,
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue!) {
                                _selectedMenus.add(menu);
                              } else {
                                _selectedMenus.remove(menu);
                              }
                            });
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
