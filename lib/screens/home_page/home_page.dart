import 'package:bodyguard/screens/home_page/widget/food_info_widget.dart';
import 'package:bodyguard/screens/home_page/widget/store_menu_widget.dart';
import 'package:bodyguard/screens/store_menu_page/store_menu_page.dart';
import 'package:bodyguard/widgets/calorie_info.dart';
import 'package:bodyguard/widgets/nutrition_info.dart';
import 'package:bodyguard/utils/notification.dart';
import 'package:bodyguard/screens/store_list_page/store_list_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/store_menu.dart';
import '../../model/store_model.dart';
import '../../providers/today_health_data_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../widgets/custom_button.dart';
import '../activity_page/activity_page.dart';
import '../body_page/body_page.dart';
import '../diet_page/diet_page.dart';
import '../my_home_page/my_home_page.dart';

import '../../services/store_service.dart';



class HomePage extends StatelessWidget {
  final List<String> _list = ["card1", "card2", "card3"];
  final DateTime now = DateTime.now();
  StoreService storeService = StoreService();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  .setCurrentTabIndex(0);
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
      body: Consumer<TodayHealthDataProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await provider.fetchTodayTotalCalories(now);
              provider.getMealTime(now);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "오늘 사용자1님은?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ]),
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
                                    Text(provider.mealTimeDetails,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                              width: 110,
                                              height: 25,
                                              child: CustomButton(
                                                onPressed: () {
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
                                              "칼로리",
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15),
                                            ),
                                            Icon(Icons.fastfood)
                                          ]),
                                      const SizedBox(height: 25),
                                      Text(
                                        "총 ${provider.todayTotalCalories.toStringAsFixed(1)}kcal",
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
                                                      const DietPage(),
                                                ),
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
                                        "${provider.todayTotalWaterIntake}ml",
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
                                                      const DietPage(),
                                                ),
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
                                              "체중",
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15),
                                            ),
                                            Icon(Icons.monitor_weight)
                                          ]),
                                      const SizedBox(height: 25),
                                      Text(
                                        "${provider.bodyWeight}kg",
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
                                        "${provider.todayTotalStepCount} 걸음",
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
                                          ))
                                    ]))),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "사용자1님, 이런건 어떠세요?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    const SizedBox(
                      height: 5,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 250,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        enableInfiniteScroll: true,
                        onPageChanged: ((index, reason) {}),
                      ),
                      items: [

                          StoreMenuWidget(storeId: 'awFDhgaAgPlvTtxr0A0H',
                              foodId: 'o7iCM8lbFt1Vpeg1TLlm', storeService: storeService),


                        StoreMenuWidget(storeId: 'JtxEXh1htARMYrmj8PeC',
                            foodId: 'v2HY5F9K3SdehELEVO5f', storeService: storeService),// foodId 전달





                      ]
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

