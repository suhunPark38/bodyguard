import 'package:bodyguard/model/storeMenu.dart';
import 'package:flutter/material.dart';
import 'package:bodyguard/model/storeModel.dart';
import '../../services/store_service.dart';
import '../shopping_page/shopping_page.dart';

class StoreListPage extends StatefulWidget {
  const StoreListPage({Key? key}) : super(key: key);

  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  final List<Store> _selectedStores = [];
  final List<StoreMenu> _selectedMenus = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가게 목록'),
        centerTitle: true,
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
                title: Text("가게 이름: ${store.StoreName}, 가게 소개: ${store.subscript}"),
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
          _showShoppingPage(context, _selectedMenus, _selectedStores);
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
                height: 200, // 적절한 높이 지정
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
                          title: Text(menu.menuName),
                          subtitle: Text('가격: ${menu.price}'),
                          value: isSelected,
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue!) {
                                if(_selectedStores.contains(store)==false) {
                                  _selectedStores.add(store);
                                }
                                _selectedMenus.add(menu);
                              } else {
                                _selectedStores.remove(store);
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



  void _showShoppingPage(BuildContext context, List<StoreMenu> selectedMenus, List<Store> selectedStores) {
    if (selectedMenus.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShoppingPage(selectedStores: selectedStores,selectedMenus: selectedMenus),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('음식이 텅 비었어요.'),
      ));
    }
  }
}
