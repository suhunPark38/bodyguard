import 'package:bodyguard/screens/health_page/health_page.dart';
import 'package:flutter/material.dart';
import '../../utils/custom_icon.dart';
import '../shopping_page/shopping_page.dart';
import 'home_page.dart';
import '../search_page/search_page.dart';
import '../identity_page/identity_page.dart';

class MyHomePage extends StatelessWidget {
  final int initialIndex;

  const MyHomePage({Key? key, required this.initialIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // 탭의 수
      initialIndex: initialIndex, // 홈페이지가 먼저 띄워지도록 함
      child: Scaffold(
        appBar: null,
        body: TabBarView(
          children: [
            HomePage(),
            const SearchPage(),
            HealthPage(),
            const ShoppingPage(),
            IdentityPage(),
          ],
        ),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              icon: Icon(
                Icons.home,
              ),
              text: '홈',
            ),
            Tab(
              icon: Icon(
                Icons.search,
              ),
              text: '검색',
            ),
            Tab(
              icon: Icon(CustomIcon.emo_sunglasses),
              child: Text('보디가드', style: TextStyle(fontSize: 13)),
            ),
            Tab(
              icon: Icon(
                Icons.shopping_cart,
              ),
              text: '쇼핑',
            ),
            Tab(
              icon: Icon(
                Icons.perm_identity_rounded,
              ),
              text: 'my',
            ),
          ],
        ),
      ),
    );
  }
}
