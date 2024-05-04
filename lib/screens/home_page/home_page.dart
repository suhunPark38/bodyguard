import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_data_provider.dart';
import '../../widgets/custom_button.dart';
import '../activity_page/activity_page.dart';
import '../body_page/body_page.dart';
import '../enter_calories_page/enter_calories_page.dart';
import '../search_page/search_page.dart';
import '../shopping_page/shopping_page.dart';

class HomePage extends StatelessWidget {

  final List<String> _list = ["card1", "card2", "card3"];
  final DateTime now = DateTime.now();


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
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body:
        Consumer<HealthDataProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(onRefresh: () async {
              await provider.fetchTodayTotalCalories(now);
              provider.getMealTime(now);
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
                              padding: EdgeInsets.all(10),
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
                                                      const ShoppingPage(),
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
                                        "총 ${provider
                                            .todayTotalCalories}kcal",
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
                                              "자세히 보기",
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
                                      const Text(
                                        "1L",
                                        style: TextStyle(
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
                                                      MyEnterCaloriesPage(),
                                                ),
                                              );
                                            },
                                            text: const Text(
                                              "자세히 보기",
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
                                      const Text(
                                        "100kg",
                                        style: TextStyle(
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
                                                      BodyPage(),
                                                ),
                                              );
                                            },
                                            text: const Text(
                                              "자세히 보기",
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
                                            Icon(Icons.accessibility_new)
                                          ]),
                                      const SizedBox(height: 25),
                                      const Text(
                                        "1520 걸음",
                                        style: TextStyle(
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
                                                      ActivityPage(),
                                                ),
                                              );
                                            },
                                            text: const Text(
                                              "자세히 보기",
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
