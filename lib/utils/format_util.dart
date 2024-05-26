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

String formatTimestamp2(DateTime timestamp) {
  return ("${timestamp.year} - ${timestamp.month} - ${timestamp.day}");
}
String formatTimestamp3(DateTime timestamp) {
  return ("${timestamp.hour} : ${timestamp.minute}");
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

String getWeekday(DateTime date) {
  switch (date.weekday) {
    case 1:
      return '월';
    case 2:
      return '화';
    case 3:
      return '수';
    case 4:
      return '목';
    case 5:
      return '금';
    case 6:
      return '토';
    case 7:
      return '일';
    default:
      return ''; // 예외 처리
  }
}