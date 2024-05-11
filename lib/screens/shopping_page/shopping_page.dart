import 'package:bodyguard/screens/shopping_page/widgets/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../map.dart';
import '../../providers/shopping_provider.dart';
import '../../utils/format_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/nutrient_info_button.dart';
import '../payment_detail_page/payment_detail_page.dart';
import '../store_list_page/store_list_page.dart';

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
                    child: const Text("모두 지우기"),
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
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: Image.network(
                                                    menu.image,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(children: [
                                                    Text(
                                                      menu.menuName,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      overflow:
                                                          TextOverflow.fade,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    NutrientInfoButton(
                                                        size: 15, menu: menu),
                                                  ]),
                                                  Text(
                                                    '개당 ${formatNumber(menu.price)}원',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${formatNumber(provider.menuQuantities[menu]! * menu.price)}원',
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
                                                          if (provider.menuQuantities[
                                                                  menu]! >
                                                              1) {
                                                            provider.updateMenuQuantity(
                                                                menu.id,
                                                                provider.menuQuantities[
                                                                        menu]! -
                                                                    1);
                                                            provider
                                                                .calculateTotalPrice();
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
                                                              (provider.menuQuantities[
                                                                          menu] ??
                                                                      1) +
                                                                  1);
                                                          provider
                                                              .calculateTotalPrice();
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
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilterButton(
                            filterType: FilterType.all,
                            onPressed: () {
                              final first = DateTime(2024);
                              final now = DateTime.now();
                              provider.setStartDate(first);
                              provider.setEndDate(now);
                              provider.setSelectedFilter(FilterType.all);
                            },
                            isSelected:
                                provider.selectedFilter == FilterType.all,
                            buttonText: "전체",
                          ),
                          FilterButton(
                            filterType: FilterType.oneWeek,
                            onPressed: () {
                              final now = DateTime.now();
                              final oneWeekAgo =
                                  now.subtract(const Duration(days: 7));
                              provider.setStartDate(oneWeekAgo);
                              provider.setEndDate(now);
                              provider.setSelectedFilter(FilterType.oneWeek);
                            },
                            isSelected:
                                provider.selectedFilter == FilterType.oneWeek,
                            buttonText: "일주일 전",
                          ),
                          FilterButton(
                            filterType: FilterType.oneMonth,
                            onPressed: () {
                              final now = DateTime.now();
                              final oneMonthAgo =
                                  DateTime(now.year, now.month - 1, now.day);
                              provider.setStartDate(oneMonthAgo);
                              provider.setEndDate(now);
                              provider.setSelectedFilter(FilterType.oneMonth);
                            },
                            isSelected:
                                provider.selectedFilter == FilterType.oneMonth,
                            buttonText: "한달 전",
                          ),
                          IconButton(
                            onPressed: () {
                              provider.toggleVisibility();
                            },
                            icon: Icon(
                              provider.isRowVisible
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                          ),
                        ],
                      ),
                      if (provider.isRowVisible)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '시작일 ${provider.selectedStartDate.year}년'
                                  ' ${provider.selectedStartDate.month}월'
                                  ' ${provider.selectedStartDate.day}일',
                                  style: const TextStyle(fontSize: 12)),
                              IconButton(
                                iconSize: 20,
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  provider.setSelectedFilter(FilterType.custom);
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2024),
                                    lastDate: DateTime.now(),
                                  );
                                  if (selectedDate != null) {
                                    provider.setStartDate(selectedDate);
                                  }
                                },
                              ),
                              Text(
                                  '종료일 ${provider.selectedEndDate.year}년'
                                  ' ${provider.selectedEndDate.month}월'
                                  ' ${provider.selectedEndDate.day}일',
                                  style: const TextStyle(fontSize: 12)),
                              IconButton(
                                iconSize: 20,
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  provider.setSelectedFilter(FilterType.custom);
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2024),
                                    lastDate: DateTime.now(),
                                  );
                                  if (selectedDate != null) {
                                    provider.setEndDate(selectedDate);
                                  }
                                },
                              ),
                            ]),
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.sortedAndFilteredPayments.length,
                          itemBuilder: (context, index) {
                            final payment =
                                provider.sortedAndFilteredPayments[index];
                            final formattedTimestamp =
                                formatTimestamp(payment.timestamp);
                            int totalFoodCount = 0;
                            for (var item in payment.menuItems) {
                              totalFoodCount += item.quantity;
                            }
                            final firstMenu =
                                payment.menuItems.first.menu.menuName;

                            // 현재 카드의 날짜
                            final currentDate = DateTime(payment.timestamp.year,
                                payment.timestamp.month, payment.timestamp.day);

                            // 오늘 날짜
                            final today = DateTime.now();

                            // 날짜가 오늘인지 확인
                            final isToday = currentDate.year == today.year &&
                                currentDate.month == today.month &&
                                currentDate.day == today.day;

                            // 날짜가 오늘인 경우 "Today" 문자열, 아닌 경우 날짜 표시
                            final dateText = isToday
                                ? '오늘'
                                : '${currentDate.year}. ${currentDate.month}. ${currentDate.day}.';

                            // 날짜가 변경되었을 경우 새로운 ListTile 추가
                            if (index == 0 ||
                                currentDate !=
                                    DateTime(
                                        provider
                                            .sortedAndFilteredPayments[
                                                index - 1]
                                            .timestamp
                                            .year,
                                        provider
                                            .sortedAndFilteredPayments[
                                                index - 1]
                                            .timestamp
                                            .month,
                                        provider
                                            .sortedAndFilteredPayments[
                                                index - 1]
                                            .timestamp
                                            .day)) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      dateText,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      title: Text(
                                        totalFoodCount > 1
                                            ? '$firstMenu와 ${totalFoodCount - 1}개의 음식'
                                            : firstMenu,
                                      ),
                                      subtitle: Text(
                                        '배달 방식: ${getDeliveryTypeString(payment.deliveryType)}'
                                        '\n가게 이름: ${payment.menuItems.first.menu.storeName}'
                                        '\n결제 상태: ${getStatusString(payment.status)}'
                                        '\n결제 금액: ${formatNumber(payment.totalPrice)}원'
                                        '\n결제 일시: $formattedTimestamp',
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.more_vert),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentDetailPage(
                                                      payment: payment),
                                            ),
                                          );
                                        },
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentDetailPage(
                                                    payment: payment),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    totalFoodCount > 1
                                        ? '$firstMenu와 ${totalFoodCount - 1}개의 음식'
                                        : firstMenu,
                                  ),
                                  subtitle: Text(
                                    '배달 방식: ${getDeliveryTypeString(payment.deliveryType)}'
                                    '\n가게 이름: ${payment.menuItems.first.menu.storeName}'
                                    '\n결제 상태: ${getStatusString(payment.status)}'
                                    '\n결제 금액: ${formatNumber(payment.totalPrice)}원'
                                    '\n결제 일시: $formattedTimestamp',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentDetailPage(
                                                  payment: payment),
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentDetailPage(payment: payment),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
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
                          onPressed: () {
                            if (provider.deliveryType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('배달 또는 포장을 선택해주세요.')));
                            } else if (provider.selectedMenus.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('음식이 텅 비었어요.')));
                            } else {
                              provider.completePayment(context);
                              provider.refreshPayments();
                              provider.handleReset(); //결제를 완료 후 장바구니 데이터 클리어
                            }
                          },
                          text: Text(
                              '${formatNumber(provider.totalPrice)}원 결제하기'),
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
