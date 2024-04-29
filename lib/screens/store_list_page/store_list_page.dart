
import 'dart:developer';

import 'package:bodyguard/model/storeMenu.dart';
import 'package:flutter/material.dart';
import 'package:bodyguard/model/storeModel.dart';
import '../../model/menuModel.dart';
import '../../services/store_service.dart';

class StoreListPage extends StatelessWidget {
  const StoreListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가게 목록'),
        centerTitle: true,
      ),
      body: StreamBuilder<List
      <Store>>(
        stream: StoreService().getStores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List
          <Store> stores = snapshot.data!;

          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              Store store = stores[index];
              return ListTile(
                title: Text("가게 이름 : ${store.StoreName}, 가게 소개 : ${store.subscript}"),
                onTap: () {
                  _showMenuDialog(context, store);
                },
              );
            },
          );
        },
      ),
    );
  }

  // 메뉴 다이얼로그 표시 메서드
  void _showMenuDialog(BuildContext context, Store store) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${store.StoreName} 메뉴'),
          content: Container(
            height: 200, // 또는 적절한 높이 지정
            width: double.maxFinite,
            child: StreamBuilder<List<StoreMenu>>(
              stream: StoreService().getStoreMenu(store.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<StoreMenu> menuList = snapshot.data!;
                return ListView(
                  children: menuList.map((menu) => ListTile(
                    title: Text(menu.menuName),
                    subtitle: Text('가격: ${menu.price}'),

                  )).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
