import 'package:flutter/material.dart';
import '../../../model/payment.dart';
import '../../../services/payment_service.dart';

class PaymentHistoryPage extends StatefulWidget {
  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  Future<List<Payment>> fetchPayments() async {
    try {
      List<Payment> payments = await PaymentService().getPayments();
      return payments;
    } catch (e) {
      print('결제 내역을 가져오는 중 오류가 발생했습니다: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Payment>>(
      future: fetchPayments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('결제 내역을 가져오는 중 오류가 발생했습니다.'),
          );
        } else {
          final payments = snapshot.data ?? [];
          if (payments.isEmpty) {
            return Center(
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
                          '\n배달 방식: ${payment.deliveryType}',
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
