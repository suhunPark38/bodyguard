import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
enum PaymentStatus { pending, completed, failed }

String getStatusString(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.pending:
      return '결제 보류';
    case PaymentStatus.completed:
      return '결제 완료';
    case PaymentStatus.failed:
      return '결제 실패';
    default:
      return '알 수 없음';
  }
}

String getDeliveryTypeString(String deliveryType) {
  switch (deliveryType) {
    case 'takeaway':
      return '포장';
    case 'delivery':
      return '배달';
    default:
      return '알 수 없음';
  }
}

String formatTimestamp(DateTime timestamp) {
  return DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(timestamp);
}

String formatNumber(int number) {
  final formatter = NumberFormat("#,###");
  return formatter.format(number);
}



String generateOrderId() {

  DateTime now = DateTime.now();
  int year = now.year;
  int month = now.month;
  int day = now.day;


  String orderIdPrefix = '$year${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}';


  String randomPart = const Uuid().v4().substring(0, 6);

  return orderIdPrefix + randomPart;
}
