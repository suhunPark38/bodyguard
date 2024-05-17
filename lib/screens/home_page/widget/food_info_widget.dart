import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../../../services/store_service.dart';

class FoodInfoWidget extends StatelessWidget {
  final String storeId;
  final String foodId;
  final StoreService storeService;

  final textStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  final TtextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  FoodInfoWidget({
    Key? key,
    required this.storeId,
    required this.foodId,
    required this.storeService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: storeService.getFoodInfo(storeId, foodId),
      builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 가져오는 중 오류가 발생했습니다.'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('음식 정보가 없습니다.'));
        } else {
          Map<String, dynamic> foodInfo = snapshot.data!;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 1,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          foodInfo['image'],
                          width: 200,
                          height: 150,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.store, color: Colors.orange[300]),
                                SizedBox(width: 8),
                                Text('${foodInfo['storeName']}', style: TtextStyle),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.restaurant_menu, color: Colors.grey[400]),
                                SizedBox(width: 8),
                                Text('${foodInfo['menuName']}', style: TtextStyle),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text('₩', style: TextStyle(color: Colors.greenAccent, fontSize: 20)),
                                SizedBox(width: 8),
                                Text('${foodInfo['price']}', style: TtextStyle),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_fire_department, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text('${foodInfo['calories']} kcal', style: textStyle),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/nutrition_icon/protein.png"),
                                size: 24.0,
                                color: Colors.brown,
                              ),
                              SizedBox(width: 8),
                              Text('단백질: ${foodInfo['protein']} g', style: textStyle),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/nutrition_icon/salt.png"),
                                size: 24.0,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(width: 8),
                              Text('나트륨: ${foodInfo['sodium']} g', style: textStyle),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/nutrition_icon/carbohydrates.png"),
                                size: 28.0,
                                color: Colors.amber[600],
                              ),
                              SizedBox(width: 8),
                              Text('탄수화물: ${foodInfo['carbohydrate']} g', style: textStyle),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.fastfood, color: Colors.pinkAccent),
                              SizedBox(width: 8),
                              Text('지방: ${foodInfo['fat']} g', style: textStyle),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/nutrition_icon/sugar.png"),
                                size: 30.0,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text('당: ${foodInfo['sugar']} g', style: textStyle),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );


        }
      },
    );
  }
}
