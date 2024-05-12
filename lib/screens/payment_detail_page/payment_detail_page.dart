import 'package:bodyguard/screens/payment_detail_page/widgets/diet_input_dialog_from_payment.dart';
import 'package:bodyguard/widgets/nutrient_info_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/payment.dart';
import '../../model/store_menu.dart';
import '../../providers/shopping_provider.dart';
import '../../utils/format_util.dart';
import '../../widgets/custom_button.dart';
import '../diet_page/diet_page.dart';

class PaymentDetailPage extends StatelessWidget {
  final Payment payment;

  const PaymentDetailPage({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ShoppingProvider>(context, listen: false).checkedMenus.clear();
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
                  bool isSelected = provider.checkedMenus.contains(menuItem.menu);
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Leading widget (이미지)
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
                                  Text(
                                    menuItem.menu.menuName,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(fontSize: 18),
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
              '결제 일시: ${formatTimestamp(payment.timestamp)}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    if (Provider.of<ShoppingProvider>(context, listen: false).checkedMenus.isNotEmpty) {
                      final checkedMenus = Provider.of<ShoppingProvider>(context, listen: false).checkedMenus;
                      _showDialogsSequentially(context, checkedMenus, payment);
                    }
                  },
                  text: const Text('칼로리 기록하기'),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
void _showDialogsSequentially(BuildContext context, List<StoreMenu> checkedMenus, Payment payment) {

  _showDialog(context, checkedMenus, 0, payment).then((_) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('칼로리와 영양성분을 확인해보세요.'),
        action: SnackBarAction(
          label: '확인하기',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const DietPage(),
              ),
            );
          },
        ),
      ),
    );
  });
}

Future<void> _showDialog(BuildContext context, List<StoreMenu> checkedMenus, int index, Payment payment) async {
  if (index < checkedMenus.length) {
    // 다이얼로그를 보여줌
    await showDialog(
      context: context,
      builder: (BuildContext builder) {
        return DietInputDialogFromPayment(payment: payment, checkedMenuIndex: index);
      },
    );
    // 현재 다이얼로그가 닫힌 후에 다음 다이얼로그를 연다
    await _showDialog(context, checkedMenus, index + 1, payment);
  }
}