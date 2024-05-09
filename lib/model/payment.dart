import 'dart:developer';

import 'package:bodyguard/model/store_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentStatus { pending, completed, failed }


class Payment {
  final String orderId;
  final String currency;
  final PaymentStatus status;
  final DateTime timestamp;
  final int totalPrice;
  final List<StoreMenu> menus;
  final String deliveryType;

  Payment({
    required this.orderId,
    required this.currency,
    required this.status,
    required this.timestamp,
    required this. totalPrice,
    required this.menus,
    required this.deliveryType,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      orderId: json['orderId'],
      currency: json['currency'],
      status: PaymentStatus.values.firstWhere((status) =>
      status.toString() == 'PaymentStatus.${json['status']}'),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      totalPrice: json['totalPrice'],
      menus: (json['menus'] as List<dynamic>).map((menuData) {
        return StoreMenu.fromJson(menuData['menuName'], menuData);
      }).toList(),
      deliveryType: json['deliveryType'],

    );

  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> menusJson =
    menus.map((menu) => menu.toJson()).toList();
    return {
      "orderId": orderId,
      "currency": currency,
      "status": status.toString().split('.').last,
      "timestamp": timestamp,
      "totalPrice": totalPrice,
      "menus": menusJson,
      "deliveryType": deliveryType,
    };
  }
}
