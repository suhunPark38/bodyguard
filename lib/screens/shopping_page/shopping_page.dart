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
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Consumer<ShoppingProvider>(builder: (context, provider, child) {
        return DefaultTabController(
          length: 2,
          initialIndex: provider.currentShoppingTabIndex,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('쇼핑'),
              centerTitle: true,
              actions: [
                if (provider.currentShoppingTabIndex == 0) // 결제하기 탭일 때
                  TextButton(
                    onPressed: provider.handleReset,
                    child: const Text("모두 지우기"),
                  ),
              ],
              bottom: TabBar(
                onTap: (index) {
                  provider.setCurrentShoppingTabIndex(index);
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
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PaymentTabWidget(provider: provider),
                  PaymentHistoryTabWidget(provider: provider),
                ],
              ),
            ),
            persistentFooterButtons:(provider.currentShoppingTabIndex == 0) ? [

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
                                Widget mapPage = const NaverMapApp();
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
                                provider.setCurrentStoreTabIndex(0);
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
                          onPressed: provider.selectedMenus.isNotEmpty
                              ? () {
                            provider.completePayment(context);
                            provider.refreshPayments();
                            provider.handleReset(); // 결제를 완료 후 장바구니 데이터 클리어
                            provider.setCurrentShoppingTabIndex(1);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyHomePage(
                                    initialIndex: 3,
                                  )),
                                  (route) => false,
                            );
                          }
                              : null,
                          text: Text(
                            '${formatNumber(provider.totalPrice)}원 결제하기',
                            style: TextStyle(
                              color: provider.selectedMenus.isNotEmpty
                                  ? Colors.white
                                  : Colors.grey, // Change the text color when disabled
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
            ] :null,
          ),
        );
      });
    });
  }
}
