import 'package:flutter/material.dart';
import 'package:bodyguard/screens/health_page/health_page.dart';
import '../shopping_page/shopping_page.dart';
import '../home_page/home_page.dart';
import '../search_page/search_page.dart';
import '../identity_page/identity_page.dart';

class MyHomePage extends StatefulWidget {
  final int initialIndex;
  final int? healthIndex;

  const MyHomePage({Key? key, required this.initialIndex, this.healthIndex}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: TabBarView(
        controller: _tabController,
        children: [
          HomePage(),
          const SearchPage(),
          HealthPage(initailIndex: widget.healthIndex ?? 0,),
          const ShoppingPage(),
          IdentityPage(),
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _tabController.animateTo(index);
          });
        },
        currentIndex: _tabController.index,
        selectedItemColor: Colors.black, // 선택된 아이템의 색상을 회색으로 설정
        unselectedItemColor: Colors.black, // 선택되지 않은 아이템의 색상을 회색으로 설정
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.black), // 아이콘 색상을 검은색으로 설정
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black), // 아이콘 색상을 검은색으로 설정
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/Bodyguard_logo.png"),
              size: 50.0,
              color: Colors.black,
              // 아이콘 색상을 검은색으로 설정
            ),
            label: "",

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.black), // 아이콘 색상을 검은색으로 설정
            label: '쇼핑',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity_rounded, color: Colors.black), // 아이콘 색상을 검은색으로 설정
            label: 'my',
          ),
        ],
      ),


    );
  }
}
