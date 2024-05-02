import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문 및 배송 내역'),
      ),
      body: ListView.builder(
        itemCount: 10, // 여기에 실제 주문 및 배송 내역의 개수를 넣어주세요
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('주문 번호: ${index + 1}'),
            subtitle: Text('상품명: 상품${index + 1} / 가격: \$10'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // 여기에 개별 주문을 탭했을 때의 동작을 넣어주세요
            },
          );
        },
      ),
    );
  }
}