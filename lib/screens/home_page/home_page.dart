import 'package:flutter/material.dart';
import '../AddressChangePage/AddressChangePage.dart';
import '../enter_calories_page/enter_calories_page.dart';
import '../activity_page/activity_page.dart';

import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';

import '../search_page/search_page.dart';


// 데이터와 색상을 관리하는 클래스
class DataColorPair {
  final double data;
  final Color color;
  final String label;

  DataColorPair({required this.data, required this.color, required this.label});
}

class HomePage extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<HomePage> {
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
    double SkeletalMuscleMass= 40;
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
      body: SingleChildScrollView(
        child: Center(
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
                      label: Text('검색'), // 버튼에 들어갈 텍스트 라벨
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.centerLeft, // 아이콘과 텍스트를 왼쪽으로 정렬
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      print('알림버튼');
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchAnchor(
                      builder: (context, controller) {
                        return SearchBar(
                          trailing: [Icon(Icons.search)],
                          controller: controller,
                          onTap: () => controller.openView(),
                          onChanged: (_) => controller.openView(),
                          onSubmitted: (value) {
                            setState(() => inputText = value);
                          },
                        );
                      },
                      suggestionsBuilder: (context, controller) {
                        return [
                          ListTile(
                            title: const Text("추천검색어1"),
                            onTap: () {
                              setState(() => controller.closeView("추천검색어1"));
                            },
                          ),
                          ListTile(
                            title: const Text("추천검색어2"),
                            onTap: () {
                              setState(() => controller.closeView("추천검색어2"));
                            },
                          ),
                        ];
                      },
                    ),
                  ),
                  Text("Input Text = $inputText", style: TextStyle(fontSize: 30))
                ],
              ),

              /*SearchBar(

                leading: Icon(Icons.search),
                trailing: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      print('장보기');
                    },
                  ),
                ],

                hintText: "검색어를 입력하세요",

              ),*/
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*Image.network(
                    'https://png.pngtree.com/thumb_back/fw800/background/20231014/pngtree-delicious-steak-lunch-box-food-delivered-in-styrofoam-with-rice-beans-image_13630864.png',
                    fit: BoxFit.cover,
                    height:200,
                    width: 300,
                  ),*/
                  SizedBox(height: 10), // Adjust spacing between image and text
                  TextButton(
                    onPressed: () {
                      print('주문');
                    },
                    child: Text("배달음식 주문하러 가기"),
                  ),
                ],
              ),
              CarouselSlider(
                items: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DonutChart(ratio: consumedCalories / recommendedCalories),
                                  SizedBox(width: 30),
                                  Row(
                                    children: [
                                      Text(
                                        '섭취한칼로리: ${consumedCalories.toString()} kcal\n'
                                            '권장 칼로리 : ${recommendedCalories.toString()} kcal',

                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
                            '골격근:', // 체중 레이블
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10), // 레이블과 체중 사이 여백
                          Text(
                            '${SkeletalMuscleMass.toString()} kg', // 체중 표시 (변수로 바꿔야 함)
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // 정보 가운데 정렬
                        children: [
                          Text(
                            '체지방:', // 체중 레이블
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10), // 레이블과 체중 사이 여백
                          Text(
                            '${bodyfat.toString()} %', // 체중 표시 (변수로 바꿔야 함)
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
                              builder: (context) => const ActivityPage(),
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
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NutritionDonut(label: '탄수화물', recommendedAmount: recommendedCarbs, consumedAmount: consumedCarbs),
                        NutritionDonut(label: '단백질', recommendedAmount: recommendedProtein, consumedAmount: consumedProtein),


                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NutritionDonut(label: '지방', recommendedAmount: recommendedFat, consumedAmount: consumedFat),
                        NutritionDonut(label: '당', recommendedAmount: recommendedSugar, consumedAmount: consumedSugar),
                      ],
                    ),

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
            ],
          ),
        ),
      ),
      bottomNavigationBar: IconButton(
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
      ),


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

class PieChart extends StatelessWidget {
  final List<DataColorPair> data;
  final double total; // 총합 추가
  const PieChart({required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: CustomPaint(
        size: Size(150, 150),
        painter: PieChartPainter(data: data, total: total),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<DataColorPair> data;
  final double total;

  PieChartPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.2;
    final double total = data.fold(0, (previousValue, element) => previousValue + element.data);

    double startAngle = -pi / 2;

    for (int i = 0; i < data.length; i++) {
      final double sweepAngle = 2 * pi * (data[i].data / total);
      final paint = Paint()
        ..color = data[i].color // 데이터에 대응하는 색상 사용
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }

    // 총합 텍스트 표시
    // 총합 텍스트 표시
    final textStyle = TextStyle(fontSize: 14, color: Colors.black); // 텍스트 스타일 설정
    final textSpan = TextSpan(
      text: 'Total: $total kcal', // 텍스트 내용과 포맷 설정
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(); // 텍스트 레이아웃 설정
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;
    final textOffset = Offset(center.dx - textWidth / 2, center.dy - textHeight / 2); // 텍스트 위치 계산

    textPainter.paint(canvas, textOffset); // 캔버스에 텍스트 그리기

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


class DonutChart extends StatelessWidget {
  final double ratio;

  const DonutChart({required this.ratio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(150, 150),
            painter: DonutChartPainter(ratio: ratio),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${(ratio * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double ratio;

  DonutChartPainter({required this.ratio});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.2;

    final paint = Paint()
      ..color = Colors.blue // 그래프 색상
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final backgroundPaint = Paint()
      ..color = Colors.grey[300]! // 배경 색상
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // 배경 그리기
    canvas.drawCircle(center, radius, backgroundPaint);

    // 그래프 그리기
    final sweepAngle = 2 * pi * ratio;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class NutritionDonut extends StatelessWidget {
  final String label;
  final double recommendedAmount; // 권장량
  final double consumedAmount; // 섭취량

  const NutritionDonut({required this.label, required this.recommendedAmount, required this.consumedAmount});

  @override
  Widget build(BuildContext context) {
    final ratio = consumedAmount / recommendedAmount; // 비율 계산
    final remainingRatio = 1.0 - ratio; // 권장량 대비 남은 비율 계산

    return SizedBox(
      height: 200,
      width: 150,
      child: Column(
        children: [
          DonutChart(ratio: ratio),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

        ],
      ),
    );
  }
}


/*class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Column(children: [
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
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityPage(),
              ),
            );
          },
          child: const Text('활동 화면'),
        ),
      ]),
    );
  }
}*/
