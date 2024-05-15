import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/menu_item.dart';
import '../model/payment.dart';
import '../utils/format_util.dart';

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
        'menuItems': payment.menuItems.map((item) => item.toJson()).toList(),
        // 수정된 부분
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
            (status) => status.toString() == 'PaymentStatus.${data['status']}',
          ),
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          totalPrice: data['totalPrice'],
          menuItems: (data['menuItems'] as List<dynamic>).map((itemData) {
            return MenuItem.fromJson(itemData);
          }).toList(),
          // 수정된 부분
          deliveryType: data['deliveryType'],
        );
      }).toList();

      return payments;
    } catch (e) {
      print('결제 정보를 가져오는 중 오류가 발생했습니다: $e');
      throw e;
    }
  }
}
