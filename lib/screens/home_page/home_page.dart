import 'package:bodyguard/providers/ad_provider.dart';
import 'package:bodyguard/providers/diet_provider.dart';
import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/screens/home_page/widget/ad_carousel.dart';
import 'package:bodyguard/utils/date_util.dart';
import 'package:bodyguard/screens/store_list_page/store_list_page.dart';
import 'package:bodyguard/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../widgets/custom_button.dart';
import '../body_page/body_page.dart';
import '../my_home_page/my_home_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});


  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // MediaQuery를 통해 화면의 크기 정보를 얻음
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

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
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              return IconButton(
                icon: Icon(notificationProvider.notificationIcon),
                onPressed: () {
                  notificationProvider.setNotificationPreference(
                      !notificationProvider.enableNotifications);

                  // 알림이 켜졌을 때 스낵바 표시
                  if (notificationProvider.enableNotifications) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('알림이 활성화되었습니다.'),
                      ),
                    );
                  }
                  // 알림이 꺼졌을 때 스낵바 표시
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('알림이 비활성화되었습니다.'),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Consumer2<HealthDataProvider, DietProvider>(
        builder: (context, healthData, diet, child) {
          return RefreshIndicator(
            onRefresh: () async {
              healthData.todayDate();
              Provider.of<AdProvider>(context, listen: false).fetchAds();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    userIDTitle(context, "님의 하루는?"),
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
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "식사",
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 15),
                                          ),
                                          Icon(Icons.restaurant_menu)
                                        ]),
                                    const SizedBox(height: 5),
                                    Text(DateUtil().getMealTime(DateTime.now()),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                              width: screenWidth * 0.3,
                                              height: screenHeight * 0.025,
                                              child: CustomButton(
                                                onPressed: () {
                                                  Provider.of<ShoppingProvider>(
                                                          context,
                                                          listen: false)
                                                      .setCurrentStoreTabIndex(
                                                          0);
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
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ))
                                        ])
                                  ]))),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "섭취 칼로리",
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15),
                                            ),
                                            Icon(Icons.local_fire_department)
                                          ]),
                                      const SizedBox(height: 25),
                                      Text(
                                        "총 ${diet.todayCalories.toStringAsFixed(1)}kcal",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                      ),
                                      const SizedBox(height: 25),
                                      SizedBox(
                                          width: screenWidth * 0.3,
                                          height: screenHeight * 0.025,
                                          child: CustomButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyHomePage(
                                                          initialIndex: 2,
                                                        )),
                                                (route) => false,
                                              );
                                            },
                                            text: const Text(
                                              "확인하기",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ))
                                    ]))),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "물",
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15),
                                            ),
                                            Icon(Icons.water_drop_sharp)
                                          ]),
                                      const SizedBox(height: 25),
                                      Text(
                                        "${(healthData.todayWater * 1000).toStringAsFixed(0)}ml",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                      ),
                                      const SizedBox(height: 25),
                                      SizedBox(
                                          width: screenWidth * 0.3,
                                          height: screenHeight * 0.025,
                                          child: CustomButton(
                                            onPressed: () {
                                              healthData.addWaterData(0.20);
                                            },
                                            text: const Text(
                                              "+ 200ml",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ))
                                    ]))),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "체중",
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15),
                                            ),
                                            Icon(Icons.monitor_weight)
                                          ]),
                                      const SizedBox(height: 25),
                                      Text(
                                        "${healthData.weight}kg",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                      ),
                                      const SizedBox(height: 25),
                                      SizedBox(
                                          width: screenWidth * 0.3,
                                          height: screenHeight * 0.025,
                                          child: CustomButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BodyPage(),
                                                ),
                                              );
                                            },
                                            text: const Text(
                                              "수정하기",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ))
                                    ]))),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "걷기",
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15),
                                            ),
                                            Icon(Icons.directions_walk)
                                          ]),
                                      const SizedBox(height: 25),
                                      Text(
                                        "${healthData.todayStep} 걸음",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                      ),
                                      const SizedBox(height: 25),
                                      SizedBox(
                                          width: screenWidth * 0.3,
                                          height: screenHeight * 0.025,
                                          child: CustomButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyHomePage(
                                                          initialIndex: 2,
                                                          healthIndex: 1,
                                                        )),
                                                (route) => false,
                                              );
                                            },
                                            text: const Text(
                                              "확인하기",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ))
                                    ]))),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      userIDTitle(context, "님, 이런건 어떠세요?"),
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    AdCarousel(),
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
