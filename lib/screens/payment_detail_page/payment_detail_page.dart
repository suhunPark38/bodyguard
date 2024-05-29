
import 'package:bodyguard/screens/payment_detail_page/widgets/diet_input_sheet_from_payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/payment.dart';
import '../../model/store_menu.dart';
import '../../providers/diet_data_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../utils/calculate_util.dart';
import '../../utils/format_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/nutrient_info_button.dart';
import '../my_home_page/my_home_page.dart';

class PaymentDetailPage extends StatelessWidget {
  final Payment payment;

  const PaymentDetailPage({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CalculateUtil calculator = CalculateUtil();
    Provider.of<ShoppingProvider>(context, listen: false).checkedMenus.clear();

    DateTime paymentTime = payment.timestamp;
    int classification = calculator.calculateClassification(paymentTime.hour);

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제 상세 정보'),
      ),
      body: Consumer<ShoppingProvider>(builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  payment.menuItems.isNotEmpty
                      ? payment.menuItems.first.menu.storeName
                      : '',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Divider(),
                ...payment.menuItems.map((menuItem) {
                  final totalPricePerItem =
                      menuItem.menu.price * menuItem.quantity;
                  bool isSelected =
                  provider.checkedMenus.contains(menuItem.menu);
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.network(
                              menuItem.menu.image,
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
                                  Flexible(child:
                                  Text(
                                    menuItem.menu.menuName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  ),
                                  NutrientInfoButton(
                                      size: 15, menu: menuItem.menu),
                                ],
                              ),
                              Text(
                                '개당 ${formatNumber(menuItem.menu.price)}원 | 수량: ${menuItem.quantity}',
                                overflow: TextOverflow.fade,
                              ),
                              Text(
                                '${formatNumber(totalPricePerItem)}원',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            if (value!) {
                              provider.checkMenu(menuItem.menu);
                            } else {
                              provider.uncheckMenu(menuItem.menu);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
            const Divider(),
            Text(
              '주문 번호: ${payment.orderId}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              '배달 방식: ${getDeliveryTypeString(payment.deliveryType)}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              '결제 상태: ${getStatusString(payment.status)}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              '결제 금액: ${formatNumber(payment.totalPrice)}원',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              '결제 일시: ${formatTimestamp(paymentTime)}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        );
      }),
      persistentFooterButtons: [
        Consumer<ShoppingProvider>(
          builder: (context, provider, child) {
            bool isButtonEnabled = provider.checkedMenus.isNotEmpty;
            return SizedBox(
              width: double.maxFinite,
              height: 40,
              child: CustomButton(
                onPressed: isButtonEnabled
                    ? () {
                  if (isButtonEnabled) {
                    final checkedMenus =
                        Provider.of<ShoppingProvider>(context, listen: false)
                            .checkedMenus;
                    _showDialogsSequentially(context, checkedMenus, payment);
                    Provider.of<DietDataProvider>(context, listen: false).setAmount(1);
                    Provider.of<DietDataProvider>(context, listen: false).setClassification(classification);
                    Provider.of<DietDataProvider>(context, listen: false).setEatingTime(paymentTime);
                  }
                }
                    : null,
                text: Text(
                  '칼로리 기록하기',
                  style: TextStyle(
                    color: isButtonEnabled
                        ? Colors.white
                        : Colors.grey, // Change the text color when disabled
                  ),
                ),
              ),
            );
          },
        ),
      ],

    );
  }
}

void _showDialogsSequentially(
    BuildContext context, List<StoreMenu> checkedMenus, Payment payment) {
  _showDialog(context, checkedMenus, 0, payment).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('칼로리와 영양성분을 확인해보세요.'),
        action: SnackBarAction(
          label: '확인하기',
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(
                    initialIndex: 2,
                  )),
                  (route) => false,
            );
          },
        ),
      ),
    );
  });
}

Future<void> _showDialog(BuildContext context, List<StoreMenu> checkedMenus,
    int index, Payment payment) async {
  if (index < checkedMenus.length) {
    // 다이얼로그를 보여줌
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext builder) {
        return DietInputSheetFromPayment(
            payment: payment, checkedMenuIndex: index);
      },
    );

    // 다이얼로그가 닫힌 후에 체크 해제
    Provider.of<ShoppingProvider>(context, listen: false).uncheckMenu(checkedMenus[index]);

    // 다음 다이얼로그를 연다
    await _showDialog(context, checkedMenus, index, payment);
  }
}

