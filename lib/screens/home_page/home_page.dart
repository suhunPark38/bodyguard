import 'package:bodyguard/providers/diet_provider.dart';
import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/utils/date_util.dart';
import 'package:bodyguard/screens/home_page/widget/store_menu_widget.dart';
import 'package:bodyguard/utils/notification.dart';
import 'package:bodyguard/screens/store_list_page/store_list_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shopping_provider.dart';
import '../../providers/user_info_provider.dart';
import '../../widgets/custom_button.dart';
import '../body_page/body_page.dart';
import '../my_home_page/my_home_page.dart';
import '../../services/store_service.dart';



class HomePage extends StatelessWidget {

  final StoreService storeService = StoreService();


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
      body:
        Consumer3<HealthDataProvider, UserInfoProvider, DietProvider>(
          builder: (context, health, userInfo, diet ,child) {
            userInfo.initializeData();
            return RefreshIndicator(onRefresh: () async {
              health.todayDate();
            }, child: Padding(
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
                                              "섭취 칼로리",
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15),
                                            ),
                                            Icon(Icons.local_fire_department)
                                          ]),
                                      const SizedBox(height: 25),
                                      Text(
                                        "${diet.totalNutritionalInfo.calories.toStringAsFixed(1)}kcal",
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
                                        "${(health
                                            .water * 1000).toStringAsFixed(0)}ml",
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
                                              health.addWaterData(0.2);
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
                                        "${health.weight}kg",
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
                                        "${health
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
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => const MyHomePage(
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
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "이런건 어떠세요?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    const SizedBox(
                      height: 5,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 350,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.1,
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
  }}
