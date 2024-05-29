import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/local_database.dart';
import '../model/fetched_diet_data.dart';
import '../screens/diet_page/widgets/diet_delete_dialog.dart';

class DietUtil {
  static final DietUtil _instance = DietUtil._internal();

  factory DietUtil() {
    return _instance;
  }

  DietUtil._internal();

  /// openAPI 이용, 식품 영양 정보 가져오기
  Future<List<FetchedDietData>> Fetchinfo(String? inputText) async {
    if (inputText == null) {
      log('값 받아오기 실패');
      throw Exception('Failed to load data');
    }
    log("받은 검색의 값${inputText}");
    log('새로운 api');
    var url =
        "http://openapi.foodsafetykorea.go.kr/api"; //sample/I2790/xml/1/5/DESC_KOR=값 &RESEARCH_YEAR=값 &MAKER_NAME=값 &FOOD_CD=값 &CHNG_DT=값";
    url += "/e9362f2ec93a4ad2ba85";
    url += "/I2790"; //데이터를 받는 키(키: 벨류 형식) ex) body:{}
    url += "/json";
    url += "/1/20/DESC_KOR=${inputText}"; //받아올 데이터의 크기 1~ 1000까지
    log(url);
    final uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      //final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      // 수정된 'items' 접근 경로
      Map<String?, dynamic> map = await json.decode(response.body);
      log(response.body);
      Map<String?, dynamic> body = map["I2790"]; // 앞서 데이터를 받는 키 입력하면 됨
      List<dynamic> item = body["row"];
      log("리스트의 크기: ${item.length}");
      List<FetchedDietData> allInfo =
          item.map((dynamic items) => FetchedDietData.fromJson(items)).toList();
      // allInfo - Json문서를 변환
      log('allInfo: ${allInfo.last.DESC_KOR}');
      return allInfo;
    } else {
      // 오류 처리 또는 빈 리스트 반환
      print('값 받아오기 실패');
      log('값 받아오기 실패');
      throw Exception('Failed to load data');
    }
  }

  /// 식단 정보 알림창 띄우기
  void showDietDetails(BuildContext context, DietData diet) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('식단 정보'),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) => DietDeleteDialog(
                                context: context, dietData: diet)),
                        child: const Icon(Icons.edit), // 휴지통 아이콘
                      ),
                    ],
                  )
                ],
              ),
              content: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('정보')),
                    DataColumn(label: Text('내용')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('메뉴이름')),
                      DataCell(Text(diet.menuName)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('먹은시간')),
                      DataCell(Text(DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                          .format(diet.eatingTime))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('먹은 양')),
                      DataCell(Text(diet.amount.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('칼로리')),
                      DataCell(Text('${diet.calories}kcal')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('탄수화물')),
                      DataCell(Text('${diet.carbohydrate}g')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('단백질')),
                      DataCell(Text('${diet.protein}g')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('지방')),
                      DataCell(Text('${diet.fat}g')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('나트륨')),
                      DataCell(Text('${diet.sodium}mg')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('당류')),
                      DataCell(Text('${diet.sugar}g')),
                    ]),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('닫기'),
                ),
                TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) =>
                          DietDeleteDialog(context: context, dietData: diet)),
                  child: const Icon(Icons.delete), // 휴지통 아이콘
                ),
              ],
            ));
  }
}
