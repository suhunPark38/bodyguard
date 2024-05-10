import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/store_menu.dart';
import '../../model/store_model.dart';
import '../../providers/shopping_provider.dart';
import '../../services/store_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/nutrient_info_button.dart';
import '../home_page/my_home_page.dart';
import '../shopping_page/shopping_page.dart';

class StoreMenuPage extends StatelessWidget {
  final Store store;

  const StoreMenuPage({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ShoppingProvider>(context, listen: false).checkedMenus.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text(store.storeName),
      ),
      body: StreamBuilder<List<StoreMenu>>(
        stream: StoreService().getStoreMenu(store.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(child: Text('데이터 없음'));
          }

          List<StoreMenu> menuList = snapshot.data!;
          return ListView.builder(
            itemCount: menuList.length,
            itemBuilder: (context, index) {
              StoreMenu menu = menuList[index];
              return Consumer<ShoppingProvider>(
                builder: (context, shoppingProvider, _) {
                  bool isSelected =
                      shoppingProvider.checkedMenus.contains(menu);
                  //bool isSelected = shoppingProvider.selectedMenus.contains(menu);
                  return ListTile(
                    leading: Image.network(
                      menu.image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.fitWidth,
                    ),
                    title: Row(
                      children: [
                        AutoSizeText(
                          menu.menuName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        NutrientInfoButton(size: 15, menu: menu),
                      ],
                    ),
                    subtitle: AutoSizeText(
                      "가격 : ${menu.price}원",
                      maxLines: 1,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 끝에 정렬
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            if (value!) {
                              shoppingProvider.checkMenu(menu);
                            } else {
                              shoppingProvider.uncheckMenu(menu);
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      if (isSelected) {
                        shoppingProvider.uncheckMenu(menu);
                      } else {
                        shoppingProvider.checkMenu(menu);
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<ShoppingProvider>(
        builder: (context, shoppingProvider, _) {
          return BottomAppBar(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        if (shoppingProvider.checkedMenus.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('메뉴를 추가할까요?')));
                        } else {
                          for (var i in shoppingProvider.checkedMenus) {
                            shoppingProvider.addMenu(store.id, i, 1);
                          }
                          shoppingProvider.checkedMenus.clear();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MyHomePage(initialIndex: 3,)),
                                (route) => false,
                          );
                        }
                      },
                      text: const Text('음식 장바구니에 추가'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
