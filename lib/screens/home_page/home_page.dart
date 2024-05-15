import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/utils/date_util.dart';
import 'package:bodyguard/utils/notification.dart';
import 'package:bodyguard/screens/store_list_page/store_list_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shopping_provider.dart';
import '../../widgets/custom_button.dart';
import '../activity_page/activity_page.dart';
import '../body_page/body_page.dart';
import '../enter_calories_page/enter_calories_page.dart';
import '../search_page/search_page.dart';
import '../shopping_page/shopping_page.dart';

class HomePage extends StatelessWidget {


  final List<String> _list = ["card1", "card2", "card3"];
  final DateTime now = DateTime.now();


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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Provider.of<ShoppingProvider>(context, listen: false).setCurrentTabIndex(0);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShoppingPage(),
                ),
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
      body:
        Consumer<HealthDataProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(onRefresh: () async {
              provider.fetchStepData(DateTime.now());
            }, child: Padding(
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
                                        mainAxisAlignment: MainAxisAlignment
                                            .end,
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
                                                  style: TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ))
                                        ])
                                  ]))),
                    ),
                    const SizedBox(height: 10),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
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
                                        "총 ${provider.totalCalorie}kcal",
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
                                                  const MyEnterCaloriesPage(),
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
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
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
                                        "${provider
                                            .water}ml",
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
                                          ))
                                    ]))),
                        Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
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
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
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
                                        "${provider
                                            .steps} 걸음",
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
                        height: 180,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.9,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        enableInfiniteScroll: true,
                        onPageChanged: ((index, reason) {}),
                      ),
                      items: _list.map((String item) {
                        return SizedBox(
                          width: double.maxFinite,
                          height: 100,
                          child: Card(child: Text(item)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            );
          },
        ),

    );
  }}
