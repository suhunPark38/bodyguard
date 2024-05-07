import 'package:flutter/material.dart';
import '../activity_page/activity_page.dart';
import '../shopping_page/shopping_page.dart';
import 'home_page.dart';
import '../search_page/search_page.dart';
import '../favorite_page/favorite_page.dart';
import '../store_list_page/store_list_page.dart';
import '../identity_page/identity_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // 탭의 수
      initialIndex: 2, // 홈페이지가 먼저 띄워지도록 함
      child: Scaffold(
        appBar: null,
        body: TabBarView(
          children: [
            const SearchPage(),
            FavoritePage(),
            HomePage(),
            ShoppingPage(),
            IdentityPage(),
          ],
        ),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: Container(
          child: Container(
            child: const TabBar(
              tabs: [

            Tab(
              icon: Icon(
                Icons.search,
              ),
              text: '검색',
            ),
            Tab(
              icon: Icon(
                Icons.favorite,
              ),
              text: '찜',
            ),
            Tab(
              icon: Icon(
                Icons.home,
              ),
              text: '홈',
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
    ),
      ),
    );
  }
}
