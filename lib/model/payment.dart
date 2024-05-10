import 'dart:developer';

import 'package:bodyguard/model/store_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'menu_item.dart';

enum PaymentStatus { pending, completed, failed }


class Payment {
  final String orderId;
  final String currency;
  final PaymentStatus status;
  final DateTime timestamp;
  final int totalPrice;
  final List<MenuItem> menuItems; // 수정된 부분
  final String deliveryType;

  Payment({
    required this.orderId,
    required this.currency,
    required this.status,
    required this.timestamp,
    required this.totalPrice,
    required this.menuItems, // 수정된 부분
    required this.deliveryType,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      orderId: json['orderId'],
      currency: json['currency'],
      status: PaymentStatus.values.firstWhere(
              (status) => status.toString() == 'PaymentStatus.${json['status']}'),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      totalPrice: json['totalPrice'],
      menuItems: (json['menuItems'] as List<dynamic>).map((itemData) {
        return MenuItem.fromJson(itemData);
      }).toList(), // 수정된 부분
      deliveryType: json['deliveryType'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> menuItemsJson =
    menuItems.map((item) => item.toJson()).toList(); // 수정된 부분
    return {
      "orderId": orderId,
      "currency": currency,
      "status": status.toString().split('.').last,
      "timestamp": timestamp,
      "totalPrice": totalPrice,
      "menuItems": menuItemsJson, // 수정된 부분
      "deliveryType": deliveryType,
    };
  }
}
