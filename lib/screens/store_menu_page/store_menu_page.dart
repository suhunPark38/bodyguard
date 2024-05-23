import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/store_menu.dart';
import '../../model/store_model.dart';
import '../../providers/shopping_provider.dart';
import '../../services/store_service.dart';
import '../../utils/format_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/nutrient_info_button.dart';
import '../my_home_page/my_home_page.dart';

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
            padding: const EdgeInsets.all(8.0),
            itemCount: menuList.length,
            itemBuilder: (context, index) {
              StoreMenu menu = menuList[index];
              return Consumer<ShoppingProvider>(
                builder: (context, provider, _) {
                  bool isSelected =
                  provider.checkedMenus.contains(menu);
                  return Card(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        if (isSelected) {
                          provider.uncheckMenu(menu);
                        } else {
                          provider.checkMenu(menu);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: Image.network(
                                  menu.image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        menu.menuName,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      NutrientInfoButton(size: 15, menu: menu),
                                    ],
                                  ),
                                  Text(
                                    "가격 : ${formatNumber(menu.price)}원",
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              // 오른쪽 끝에 정렬
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    if (value!) {
                                      provider.checkMenu(menu);
                                    } else {
                                      provider.uncheckMenu(menu);
                                    }
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<ShoppingProvider>(
        builder: (context, provider, _) {
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
                        if (provider.checkedMenus.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('메뉴를 추가할까요?')));
                        } else {
                          for (var i in provider.checkedMenus) {
                            provider.addMenu(store.id, i, 1);
                          }
                          provider.checkedMenus.clear();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage(
                                      initialIndex: 3,
                                    )),
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
