// FoodInfoWidget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/store_service.dart';

class FoodInfoWidget extends StatelessWidget {
  final String storeId;
  final String foodId;
  final StoreService storeService;

  final textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold, // 폰트 굵기
    color: Colors.black, // 텍스트 색상
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
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> foodInfo = snapshot.data!;
            return
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          // 이미지와 텍스트를 함께 감싸는 컨테이너
                          color: snapshot.connectionState == ConnectionState.done ? null : Colors.grey,
                          child: Row(
                            children: [
                              // 이미지
                              Image.network(
                                foodInfo['image'],
                                fit: BoxFit.fitWidth,
                                width: 200,
                              ),
                              SizedBox(width: 20,),
                              // 텍스트
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center, // 텍스트를 세로 방향으로 중앙에 정렬
                                children: [
                                  Text('이름: ${foodInfo['menuName']}', style: textStyle), // 텍스트 스타일 적용
                                  Text('가격: ${foodInfo['price']} 원', style: textStyle), // 텍스트 스타일 적용
                                  Text('칼로리: ${foodInfo['calories']} kcal', style: textStyle), // 텍스트 스타일 적용
                                  Text('탄수화물: ${foodInfo['carbohydrate']} g', style: textStyle), // 텍스트 스타일 적용
                                  Text('단백질: ${foodInfo['protein']} g', style: textStyle), // 텍스트 스타일 적용
                                  Text('지방: ${foodInfo['fat']} g', style: textStyle), // 텍스트 스타일 적용
                                  Text('나트륨: ${foodInfo['sodium']} g', style: textStyle), // 텍스트 스타일 적용
                                  Text('당: ${foodInfo['sugar']} g', style: textStyle), // 텍스트 스타일 적용
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 로딩 인디케이터를 숨기는 데 사용될 위젯
                      // 이미지 로딩이 완료되면 높이가 0이 됩니다.
                      SizedBox(
                        height: snapshot.connectionState == ConnectionState.done ? 0 : 20,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              );



          } else if (snapshot.hasError) {
            return Text('데이터를 가져오는 중 오류가 발생했습니다.');
          } else {
            return Text('음식 정보가 없습니다.');
          }
        }
      },
    );
  }

}
