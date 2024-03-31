import 'package:flutter/material.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'favorite_page.dart';
import 'shopping_page.dart';
import 'identity_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // 탭의 수
      child: Scaffold(
        appBar: null,
        body: TabBarView(
          children: [
            HomePage(),
            SearchPage(),
            FavoritePage(),
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
                  icon: Icon(
                    Icons.favorite,
                  ),
                  text: '찜',
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
