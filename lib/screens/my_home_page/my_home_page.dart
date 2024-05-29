import 'package:bodyguard/screens/health_page/health_page.dart';
import 'package:flutter/material.dart';
import '../shopping_page/shopping_page.dart';
import '../home_page/home_page.dart';
import '../search_page/search_page.dart';
import '../identity_page/identity_page.dart';

class MyHomePage extends StatelessWidget {
  final int initialIndex;
  final int? healthIndex;
  final int? shoppingIndex;

  const MyHomePage({Key? key, required this.initialIndex, this.healthIndex, this.shoppingIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // 탭의 수
      initialIndex: initialIndex, // 시작 탭을 받을 수 있도록
      child: Scaffold(
        appBar: null,
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomePage(),
            const SearchPage(),
            HealthPage(initialIndex: healthIndex ?? 0,),
            ShoppingPage(initialIndex: shoppingIndex ?? 0,),
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
              icon: ImageIcon(
                AssetImage("assets/body_logo_icon.png"),
                size: 50.0,
              ),
              text: '',
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
