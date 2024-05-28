import 'package:flutter/cupertino.dart';
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
        ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 80,
                child: FilterButton(
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
              ),
              SizedBox(
                width: 90,
                child: FilterButton(
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
              ),
              SizedBox(
                width: 80,
                child: FilterButton(
                  filterType: FilterType.oneMonth,
                  onPressed: () {
                    final now = DateTime.now();
                    final oneMonthAgo =
                    DateTime(now.year, now.month - 1, now.day);
                    provider.setStartDate(oneMonthAgo);
                    provider.setEndDate(now);
                    provider.setSelectedFilter(FilterType.oneMonth);
                  },
                  isSelected: provider.selectedFilter == FilterType.oneMonth,
                  buttonText: "한달 전",
                ),
              ),
            ],
          ),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
                      await _showDatePicker(context, true);
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
                      await _showDatePicker(context, false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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

              final currentDate = DateTime(payment.timestamp.year,
                  payment.timestamp.month, payment.timestamp.day);
              final today = DateTime.now();
              final isToday = currentDate.year == today.year &&
                  currentDate.month == today.month &&
                  currentDate.day == today.day;
              final dateText = isToday
                  ? '오늘'
                  : '${currentDate.year}. ${currentDate.month}. ${currentDate.day}.';

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

  Future<void> _showDatePicker(BuildContext context, bool isStartDate) async {
    final DateTime initialDate = isStartDate
        ? provider.selectedStartDate
        : provider.selectedEndDate;
    final DateTime? selectedDate = await (Theme.of(context).platform ==
        TargetPlatform.iOS // 플랫폼 체크
        ? showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => _buildDatePickerCupertino(context, initialDate),
    )
        : showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    ));

    if (selectedDate != null) {
      if (isStartDate) {
        provider.setStartDate(selectedDate);
      } else {
        provider.setEndDate(selectedDate);
      }
    }
  }

  Widget _buildDatePickerCupertino(BuildContext context, DateTime initialDate) {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: initialDate,
      minimumDate: DateTime(2024),
      maximumDate: DateTime.now(),
      onDateTimeChanged: (DateTime newDateTime) {
        // CupertinoDatePicker에서 날짜가 변경될 때마다 실행될 콜백
        // 여기서 선택한 날짜를 저장하거나 처리할 수 있음
      },
    );
  }
}