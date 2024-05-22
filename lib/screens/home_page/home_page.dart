import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/utils/date_util.dart';
import 'package:bodyguard/utils/notification.dart';
import 'package:bodyguard/screens/store_list_page/store_list_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/diet_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../providers/user_info_provider.dart';
import '../../services/store_service.dart';
import '../../widgets/custom_button.dart';
import '../activity_page/activity_page.dart';
import '../identity_page/myInfo_detail_page.dart';
import '../my_home_page/my_home_page.dart';
import '../store_menu_page/store_menu_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dietProvider = Provider.of<DietProvider>(context, listen: false);
    final storeService = StoreService();  // StoreService 인스턴스 생성

    return Scaffold(
      appBar: AppBar(
        title: const Text("BODYGUARD"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                      initialIndex: 1,
                    )),
                    (route) => false,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Provider.of<ShoppingProvider>(context, listen: false)
                  .setCurrentShoppingTabIndex(0);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                      initialIndex: 3,
                    )),
                    (route) => false,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              FlutterLocalNotification.showNotification();
            },
          ),
        ],
      ),
      body: Consumer2<HealthDataProvider, UserInfoProvider>(
        builder: (context, provider, userInfo, child) {
          userInfo.initializeData();
          return RefreshIndicator(
            onRefresh: () async {
              //provider.fetchStepData(DateTime.now());
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    userInfo.D("님의 하루는?"),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 120,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "식사",
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15),
                                  ),
                                  Icon(Icons.restaurant_menu),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateUtil().getMealTime(DateTime.now()),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 110,
                                    height: 25,
                                    child: CustomButton(
                                      onPressed: () {
                                        Provider.of<ShoppingProvider>(context, listen: false)
                                            .setCurrentStoreTabIndex(0);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StoreListPage(),
                                          ),
                                        );
                                      },
                                      text: const Text(
                                        "주문하기",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "칼로리",
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15),
                                    ),
                                    Icon(Icons.local_fire_department),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  "총 ${dietProvider.todayCalories.toStringAsFixed(1)}kcal",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                  width: 110,
                                  height: 20,
                                  child: CustomButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const MyHomePage(
                                              initialIndex: 2,
                                            )),
                                            (route) => false,
                                      );
                                    },
                                    text: const Text(
                                      "확인하기",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "물",
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15),
                                    ),
                                    Icon(Icons.water_drop_sharp),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  "${provider.water * 1000}ml",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                  width: 110,
                                  height: 20,
                                  child: CustomButton(
                                    onPressed: () {
                                      provider.addWaterData(0.25);
                                    },
                                    text: const Text(
                                      "추가하기",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "체중",
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15),
                                    ),
                                    Icon(Icons.monitor_weight),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  "${provider.weight}kg",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                  width: 110,
                                  height: 20,
                                  child: CustomButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const MyInfoDetailPage(),
                                        ),
                                      );
                                    },
                                    text: const Text(
                                      "수정하기",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "걷기",
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15),
                                    ),
                                    Icon(Icons.directions_walk),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  "${provider.steps} 걸음",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                  width: 110,
                                  height: 20,
                                  child: CustomButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const ActivityPage(),
                                        ),
                                      );
                                    },
                                    text: const Text(
                                      "확인하기",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        userInfo.D("님 이런건 어떠세요?"),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                      future: Future.wait([
                        storeService.getStoreById("nFyINsmkNwpJ9vfyv2Gz"),
                        storeService.getStoreById("awFDhgaAgPlvTtxr0A0H"),
                        storeService.getStoreById("JtxEXh1htARMYrmj8PeC"),
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: Text("No stores found"));
                        } else {
                          final stores = snapshot.data as List<dynamic>;  // 데이터 타입 명시
                          final List<Map<String, dynamic>> _carouselItems = [
                            {
                              "imageUrl": "https://firebasestorage.googleapis.com/v0/b/bodyguard-d274c.appspot.com/o/ad%2Fhand%20to%20hand%20coffee.png?alt=media&token=cee33bb2-2457-4440-a489-9cff7d20ad48",
                              "page": StoreMenuPage(store: stores[0]),
                            },
                            {
                              "imageUrl":"https://firebasestorage.googleapis.com/v0/b/bodyguard-d274c.appspot.com/o/ad%2F%E1%84%89%E1%85%B5%E1%84%82%E1%85%A1%E1%84%82%E1%85%A9.png?alt=media&token=b04656c1-afb4-4568-b3b3-709637adfce7",
                              "page": StoreMenuPage(store: stores[1]),
                            },
                            {
                              "imageUrl":"https://firebasestorage.googleapis.com/v0/b/bodyguard-d274c.appspot.com/o/ad%2F%E1%84%89%E1%85%A1%E1%86%B7%E1%84%89%E1%85%A5%E1%86%AB%E1%84%87%E1%85%A1%E1%86%AB%E1%84%8C%E1%85%A5%E1%86%B7.png?alt=media&token=54ddce9f-1892-4589-b7b5-1c5cae87fe43",
                              "page": StoreMenuPage(store: stores[2]),
                            }
                          ];

                          return CarouselSlider(
                            options: CarouselOptions(
                              height: 210,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.9,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 4),
                              enableInfiniteScroll: true,
                            ),
                            items: _carouselItems.map((item) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => item["page"]),
                                  );
                                },
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: Card(
                                    child: Image.network(
                                      item["imageUrl"],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
