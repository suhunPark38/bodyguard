import 'package:flutter/material.dart';
import '../../model/data_color_pair.dart';
import '../AddressChangePage/AddressChangePage.dart';
import '../Body_page/Body_page.dart';
import '../OrderHistoryPage/OrderHistoryPage.dart';
import '../enter_calories_page/enter_calories_page.dart';
import '../activity_page/activity_page.dart';

import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';

import '../search_page/search_page.dart';
import '../shopping_page/shopping_page.dart';


import '../../widgets/pie_chart.dart'; // PieChart 클래스를 포함한 파일 import
import '../../widgets/donut_chart.dart'; // DonutChart 클래스를 포함한 파일 import
import '../../widgets/nutrition_donut.dart'; // NutritionDonut 클래스를 포함한 파일 import



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 예시용 칼로리와 영양소 비율
  double recommendedCalories = 1; // 예시용 권장 칼로리
  double consumedCalories = 0; // 예시용 섭취한 칼로리
  double recommendedCarbs = 1; // 예시용 탄수화물 권장량
  double consumedCarbs = 0; // 예시용 탄수화물 섭취량
  double recommendedProtein = 1; // 예시용 단백질 권장량
  double consumedProtein = 0; // 예시용 단백질 섭취량
  double recommendedFat = 1; // 예시용 지방 권장량
  double consumedFat = 0; // 예시용 지방 섭취량
  double recommendedSugar = 1; // 예시용 당 권장량
  double consumedSugar = 0;
  var inputText; // 예시용 당 섭취량

  @override
  Widget build(BuildContext context) {
    double bodyfat=13;
    double weight =70.0;
    double Fweight= 80;
    double Lweight =60.0;
    double stairClimbingCalories = 200; // 계단 오르기
    double walkingCalories = 500; // 걷기
    double gymCalories = 300; // 헬스
    double sum=stairClimbingCalories+walkingCalories+gymCalories;

    // 파이 차트를 구성하는 데이터와 색상 리스트
    final List<DataColorPair> pieChartData = [
      DataColorPair(data: stairClimbingCalories, color: _getRandomColor(), label: '계단 오르기'),
      DataColorPair(data: walkingCalories, color: _getRandomColor(), label: '걷기'),
      DataColorPair(data: gymCalories, color: _getRandomColor(), label: '헬스'),
    ];

    return Scaffold(
      appBar: AppBar(

        title: const Text('BODYGUARD'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.notifications_none),
          onPressed: () {
            print('알림버튼');
          },
        ),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressChangePage(), // 주소지 변경 페이지로 이동
                ),
              );
            },
            child: Text("주소지 변경"),
          ),
        ],
      ),
      body:
      Container(
        color: Colors.grey[200],
        child: SingleChildScrollView(

        child: Center(
          child: Container(
            color: Colors.white,
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(

                children: [
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.search), // 버튼에 들어갈 아이콘
                      label: Text('검색어를 입력하세요'), // 버튼에 들어갈 텍스트 라벨
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.centerLeft, // 아이콘과 텍스트를 왼쪽으로 정렬
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderHistoryPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),



              SizedBox(height: 10),
              Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShoppingPage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/order.png',
                      fit: BoxFit.cover,
                      height: 200,
                      width: 300,
                    ),
                  ),



                  SizedBox(height: 10),
                  // Adjust spacing between image and text
                  ElevatedButton(

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShoppingPage(),
                        ),
                      );
                    },
                    child: Text("배달음식 주문하러 가기"),
                  ),
                ],
              ),
              CarouselSlider(

                items: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PieChart(data: pieChartData, total: sum), // 총합 전달
                          SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '활동별 소모 칼로리',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              for (var dataColorPair in pieChartData)
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: dataColorPair.color,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${dataColorPair.label}: ${dataColorPair.data} kcal',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],

                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ActivityPage(),
                            ),
                          );
                        },
                        child: const Text('활동량 확인하기'),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // 정보 가운데 정렬
                        children: [
                          Text(
                            '시작 몸무게:', // 체중 레이블
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10), // 레이블과 체중 사이 여백
                          Text(
                            '${Fweight.toString()} kg', // 체중 표시 (변수로 바꿔야 함)
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 20), // 여백 추가 (외관 향상)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // 정보 가운데 정렬
                        children: [
                          Text(
                            '오늘의 몸무게:', // 체중 레이블
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10), // 레이블과 체중 사이 여백
                          Text(
                            '${weight.toString()} kg', // 체중 표시 (변수로 바꿔야 함)
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // 정보 가운데 정렬
                        children: [
                          Text(
                            '목표 몸무게:', // 체중 레이블
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10), // 레이블과 체중 사이 여백
                          Text(
                            '${Lweight.toString()} kg', // 체중 표시 (변수로 바꿔야 함)
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BodyPage(),
                            ),
                          );
                        },
                        child: const Text('몸무게 수정하기'),
                      ),
                    ],
                  ),

                ],
                options: CarouselOptions(
                  height: 300,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // 원하는 OnTap 기능 구현 (예: 새로운 페이지로 이동)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyEnterCaloriesPage(),
                    ),

                  );
                },
                child: Container(

                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DonutChart(ratio: consumedCalories / recommendedCalories),
                          SizedBox(height: 20),
                          Text(
                            '섭취한칼로리: ${consumedCalories.toString()} kcal\n'
                                '권장 칼로리 : ${recommendedCalories.toString()} kcal',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 30,
                        children: [
                          NutritionDonut(
                            label: '탄수화물',
                            recommendedAmount: recommendedCarbs,
                            consumedAmount: consumedCarbs,
                          ),
                          NutritionDonut(
                            label: '단백질',
                            recommendedAmount: recommendedProtein,
                            consumedAmount: consumedProtein,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 30,
                        alignment: WrapAlignment.center,
                        children: [
                          NutritionDonut(
                            label: '지방',
                            recommendedAmount: recommendedFat,
                            consumedAmount: consumedFat,
                          ),
                          NutritionDonut(
                            label: '당',
                            recommendedAmount: recommendedSugar,
                            consumedAmount: consumedSugar,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyEnterCaloriesPage(),
                            ),
                          );
                        },
                        child: const Text('칼로리 입력 화면'),
                      ),
                    ],
                  ),
                ),

              ),

            ],
          ),
        ),
        ),
      ),
    ),
      /*bottomNavigationBar: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("기록하기"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "권장 칼로리 입력",
                        labelText: "권장 칼로리",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        recommendedCalories = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "섭취한 칼로리 입력",
                        labelText: "섭취한 칼로리",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        consumedCalories = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "권장 탄수화물 입력",
                        labelText: "권장 탄수화물",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        recommendedCarbs = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "섭취한 탄수화물 입력",
                        labelText: "섭취한 탄수화물",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        consumedCarbs = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "권장 단백질 입력",
                        labelText: "권장 단백질",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        recommendedProtein = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "섭취한 단백질 입력",
                        labelText: "섭취한 단백질",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        consumedProtein = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "권장 지방 입력",
                        labelText: "권장 지방",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        recommendedFat = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "섭취한 지방 입력",
                        labelText: "섭취한 지방",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        consumedFat = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "권장 당 입력",
                        labelText: "권장 당",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        recommendedSugar = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "섭취한 당 입력",
                        labelText: "섭취한 당",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        consumedSugar = double.parse(value);
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("취소"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 여기서 입력받은 값으로 처리
                      Navigator.of(context).pop();
                    },
                    child: Text("확인"),
                  ),
                ],
              );
            },
          );
        },
        icon: Icon(Icons.edit),
      ),*/


    );
  }


  // 랜덤 색상 생성 함수
  Color _getRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }
}












