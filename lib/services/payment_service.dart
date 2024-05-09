import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/payment.dart';
import '../model/store_menu.dart';


class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 결제 정보를 Firestore에 추가하는 메서드
  Future<void> addPayment(Payment payment) async {
    try {
      await _firestore.collection('payments').add({
        'orderId': payment.orderId,
        'currency': payment.currency,
        'status': payment.status.toString().split('.').last,
        'timestamp': payment.timestamp,
        'totalPrice': payment.totalPrice,
        'menus': payment.menus.map((menu) => menu.toJson()).toList(),
        'deliveryType': payment.deliveryType,
      });

      print('결제 정보가 성공적으로 저장되었습니다.');
    } catch (e) {
      print('결제 정보 저장 중 오류가 발생했습니다: $e');
      throw e; // 오류를 호출자에게 다시 던집니다.
    }
  }

  // 결제 정보를 Firestore에서 가져오는 메서드
  Future<List<Payment>> getPayments() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('payments').get();

      final List<Payment> payments = snapshot.docs.map((doc) {
        final data = doc.data();
        return Payment(
          orderId: data['orderId'],
          currency: data['currency'],
          status: PaymentStatus.values.firstWhere(
                  (status) => status.toString() == 'PaymentStatus.${data['status']}'),
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          totalPrice: data['totalPrice'],
          menus: (data['menus'] as List<dynamic>).map((menuData) {
            // Convert each menu data to StoreMenu object
            return StoreMenu.fromJson(menuData['id'], menuData);
          }).toList(),
          deliveryType: data['deliveryType']
        );
      }).toList();

      return payments;
    } catch (e) {
      print('결제 정보를 가져오는 중 오류가 발생했습니다: $e');
      throw e;
    }
  }

}
