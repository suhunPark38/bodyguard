import 'package:flutter/material.dart';

import '../../../providers/shopping_provider.dart';
import '../../../utils/format_util.dart';
import '../../payment_detail_page/payment_detail_page.dart';
import 'filter_button.dart';

class PaymentHistoryTabWidget extends StatelessWidget {
  final ShoppingProvider provider;

  const PaymentHistoryTabWidget({Key? key, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              isSelected: provider.selectedFilter == FilterType.all,
              buttonText: "전체",
            ),
            FilterButton(
              filterType: FilterType.oneWeek,
              onPressed: () {
                final now = DateTime.now();
                final oneWeekAgo = now.subtract(const Duration(days: 7));
                provider.setStartDate(oneWeekAgo);
                provider.setEndDate(now);
                provider.setSelectedFilter(FilterType.oneWeek);
              },
              isSelected: provider.selectedFilter == FilterType.oneWeek,
              buttonText: "일주일 전",
            ),
            FilterButton(
              filterType: FilterType.oneMonth,
              onPressed: () {
                final now = DateTime.now();
                final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
                provider.setStartDate(oneMonthAgo);
                provider.setEndDate(now);
                provider.setSelectedFilter(FilterType.oneMonth);
              },
              isSelected: provider.selectedFilter == FilterType.oneMonth,
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              final payment = provider.sortedAndFilteredPayments[index];
              final formattedTimestamp = formatTimestamp(payment.timestamp);
              int totalFoodCount = 0;
              for (var item in payment.menuItems) {
                totalFoodCount += item.quantity;
              }
              final firstMenu = payment.menuItems.first.menu.menuName;

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
                          provider.sortedAndFilteredPayments[index - 1]
                              .timestamp.year,
                          provider.sortedAndFilteredPayments[index - 1]
                              .timestamp.month,
                          provider.sortedAndFilteredPayments[index - 1]
                              .timestamp.day)) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        dateText,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          totalFoodCount > 1
                              ? '$firstMenu, ${totalFoodCount - 1}개의 음식'
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
                                    PaymentDetailPage(payment: payment),
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
                    ),
                  ],
                );
              } else {
                return Card(
                  child: ListTile(
                    title: Text(
                      totalFoodCount > 1
                          ? '$firstMenu, ${totalFoodCount - 1}개의 음식'
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
                                PaymentDetailPage(payment: payment),
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
    );
  }
}
