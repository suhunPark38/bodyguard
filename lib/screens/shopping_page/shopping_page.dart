import 'package:bodyguard/screens/shopping_page/widgets/payment_history_tab_widget.dart';
import 'package:bodyguard/screens/shopping_page/widgets/payment_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../map.dart';
import '../../providers/shopping_provider.dart';
import '../../utils/format_util.dart';
import '../../widgets/custom_button.dart';
import '../my_home_page/my_home_page.dart';
import '../store_list_page/store_list_page.dart';

class ShoppingPage extends StatelessWidget {
  final int initialIndex;

  const ShoppingPage({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingProvider>(builder: (context, provider, child) {
      return DefaultTabController(
          initialIndex: initialIndex,
          length: 2,
          child: Builder(builder: (context) {
            final TabController tabController =
                DefaultTabController.of(context);
            return Scaffold(
                appBar: AppBar(
                  title: const Text('쇼핑'),
                  centerTitle: true,
                  actions: [
                    ValueListenableBuilder<int>(
                        valueListenable: tabController.animation!
                            .drive(IntTween(begin: 0, end: 1)),
                        builder: (context, value, child) {
                          return value == 0
                              ? TextButton(
                                  onPressed: provider.handleReset,
                                  child: const Text("모두 지우기"),
                                )
                              : const SizedBox.shrink();
                        })
                  ],
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: '결제하기'),
                      Tab(text: '결제 내역'),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TabBarView(
                    children: [
                      PaymentTabWidget(provider: provider),
                      PaymentHistoryTabWidget(provider: provider),
                    ],
                  ),
                ),
                persistentFooterButtons: [
                  ValueListenableBuilder<int>(
                      valueListenable: tabController.animation!
                          .drive(IntTween(begin: 0, end: 1)),
                      builder: (context, value, child) {
                        return value == 0
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 'delivery',
                                                  groupValue:
                                                      provider.deliveryType,
                                                  onChanged: provider
                                                      .handleDeliveryTypeChange,
                                                ),
                                                const Text("배달"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 'takeaway',
                                                  groupValue:
                                                      provider.deliveryType,
                                                  onChanged: provider
                                                      .handleDeliveryTypeChange,
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
                                            text: const Text(
                                              '메뉴 담기',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            onPressed: () async {
                                              provider.completePayment(context);
                                              provider.refreshPayments();
                                              provider.handleReset(); // 결제를 완료 후 장바구니 데이터 클리어
                                              provider.setCurrentStoreTabIndex(0);
                                              provider.setCurrentStoreTabIndex(0);
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => StoreListPage(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "결제 금액",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${formatNumber(provider.totalPrice)}원",
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
                                        onPressed: provider
                                                .selectedMenus.isNotEmpty
                                            ? () {
                                                provider
                                                    .completePayment(context);
                                                provider.refreshPayments();
                                                provider
                                                    .handleReset(); // 결제를 완료 후 장바구니 데이터 클리어
                                                tabController.animateTo(1);
                                              }
                                            : null,
                                        text: Text(
                                          '${formatNumber(provider.totalPrice)}원 결제하기',
                                          style: TextStyle(
                                            color: provider
                                                    .selectedMenus.isNotEmpty
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink();
                      })
                ]);
          }));
    });
  }
}
