import 'package:bodyguard/providers/shopping_provider.dart';
import 'package:bodyguard/screens/store_list_page/store_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/payment.dart';
import '../../map.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/nutrient_info_button.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Consumer<ShoppingProvider>(builder: (context, provider, child) {
        return DefaultTabController(
          length: 2,
          initialIndex: provider.currentTabIndex,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('쇼핑'),
              centerTitle: true,
              actions: [
                if (provider.currentTabIndex == 0) //결제하기 탭일때
                  TextButton(
                    onPressed: provider.handleReset,
                    child: const Text("초기화하기"),
                  ),
              ],
              bottom: TabBar(
                onTap: (index) {
                  provider.setCurrentTabIndex(index);
                },
                tabs: const [
                  Tab(text: '결제하기'),
                  Tab(text: '결제 내역'),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TabBarView(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              for (var entry in provider.storeMenuMap.entries)
                                Column(
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    for (var menu in entry.value)
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(children: [
                                                    Text(
                                                      menu.menuName,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      softWrap: true,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    NutrientInfoButton(
                                                        size: 15, menu: menu),
                                                  ]),
                                                  Text(
                                                    '개당 ${menu.price}원',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${provider.menuQuantities[menu]! * menu.price}원',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      provider.removeMenu(menu);
                                                    },
                                                    child:
                                                        const Icon(Icons.close),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.remove),
                                                        onPressed: () {
                                                          if (provider.menuQuantities[menu]! > 1) {
                                                            provider.updateMenuQuantity(
                                                                menu.id,
                                                                provider.menuQuantities[menu]! - 1);
                                                            provider.calculateTotalPrice();
                                                          }
                                                        },
                                                      ),
                                                      Text(
                                                        '${provider.menuQuantities[menu]}',
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.add),
                                                        onPressed: () {
                                                          provider.updateMenuQuantity(
                                                              menu.id,
                                                              (provider.menuQuantities[menu] ?? 1) + 1);
                                                          provider.calculateTotalPrice();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<List<Payment>>(
                    future: provider.fetchPayments(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('결제 내역을 가져오는 중 오류가 발생했습니다.'),
                        );
                      } else {
                        final payments = snapshot.data ?? [];
                        if (payments.isEmpty) {
                          return const Center(
                            child: Text('결제 내역이 없습니다.'),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: payments.length,
                            itemBuilder: (context, index) {
                              final payment = payments[index];
                              return Card(
                                  child: ListTile(
                                title: Text('주문 번호: ${payment.orderId}'),
                                subtitle: Text(
                                    '결제 상태: ${payment.status.toString().split('.').last}'
                                    '\n결제 일시: ${payment.timestamp}'
                                    '\n결제 금액: ${payment.totalPrice}'
                                    '\n배달 방식: ${payment.deliveryType}'),
                              ));
                            },
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            persistentFooterButtons: [
              if (provider.currentTabIndex == 0) //결제하기 탭일때
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: [
                                  Radio(
                                    value: 'delivery',
                                    groupValue: provider.deliveryType,
                                    onChanged:
                                        provider.handleDeliveryTypeChange,
                                  ),
                                  const Text("배달"),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'takeaway',
                                    groupValue: provider.deliveryType,
                                    onChanged:
                                        provider.handleDeliveryTypeChange,
                                  ),
                                  const Text("포장"),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 90,
                            height: 20,
                            child: CustomButton(
                              onPressed: () async {
                                Widget mapPage = await MapRun();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => mapPage,
                                  ),
                                );
                              },
                              text: const Text(
                                '가게 위치',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 90,
                            height: 20,
                            child: CustomButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoreListPage(),
                                  ),
                                );
                              },
                              text: const Text(
                                '메뉴 담기',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "결제 금액",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${provider.totalPrice}원",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        height: 40,
                        child: CustomButton(
                          onPressed: () {
                            if (provider.deliveryType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('배달 또는 포장을 선택해주세요.')));
                            } else if (provider.selectedMenus.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('음식이 텅 비었어요.')));
                            } else {
                              provider.completePayment();
                              provider.refreshPayments();
                              provider.handleReset(); //결제를 완료 후 장바구니 데이터 클리어
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('결제를 성공했습니다.')));
                            }
                          },
                          text: Text('${provider.totalPrice}원 결제하기'),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
            ],
          ),
        );
      });
    });
  }
}
