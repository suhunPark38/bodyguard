import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Value2 {

  /*
  1	NUM	번호
2	FOOD_CD	식품코드
3	SAMPLING_REGION_NAME	지역명
4	SAMPLING_MONTH_NAME	채취월
5	SAMPLING_REGION_CD	지역코드
6	SAMPLING_MONTH_CD	채취월코드
7	GROUP_NAME	식품군
8	DESC_KOR	식품이름
9	RESEARCH_YEAR	조사년도
10	MAKER_NAME	제조사명
11	SUB_REF_NAME	자료출처
12	SERVING_SIZE	총내용량
13	SERVING_UNIT	총내용량단위
14	NUTR_CONT1	열량(kcal)(1회제공량당)
15	NUTR_CONT2	탄수화물(g)(1회제공량당)
16	NUTR_CONT3	단백질(g)(1회제공량당)
17	NUTR_CONT4	지방(g)(1회제공량당)
18	NUTR_CONT5	당류(g)(1회제공량당)
19	NUTR_CONT6	나트륨(mg)(1회제공량당)
20	NUTR_CONT7	콜레스테롤(mg)(1회제공량당)
21	NUTR_CONT8	포화지방산(g)(1회제공량당)
22	NUTR_CONT9	트랜스지방(g)(1회제공량당)
  */


  final String DESC_KOR, MAKER_NAME, SERVING_SIZE, SERVING_UNIT, NUTR_CONT1,
      NUTR_CONT2, NUTR_CONT3
  , NUTR_CONT4, NUTR_CONT5, NUTR_CONT6, NUTR_CONT7, NUTR_CONT8, NUTR_CONT9;

  Value2({
    required this.DESC_KOR,
    required this.MAKER_NAME,
    required this.SERVING_SIZE,
    required this.SERVING_UNIT,
    required this.NUTR_CONT1,
    required this.NUTR_CONT2,
    required this.NUTR_CONT3,
    required this.NUTR_CONT4,
    required this.NUTR_CONT5,
    required this.NUTR_CONT6,
    required this.NUTR_CONT7,
    required this.NUTR_CONT8,
    required this.NUTR_CONT9
  });

  factory Value2.fromJson(Map<String, dynamic> json){
    return Value2(
      DESC_KOR: json['DESC_KOR'].isEmpty ? "미확인" : json['DESC_KOR'],
      MAKER_NAME: json['MAKER_NAME'].isEmpty ? "미확인" : json['MAKER_NAME'],
      SERVING_SIZE: json['SERVING_SIZE'].isEmpty ? "미확인" : json['SERVING_SIZE'],
      SERVING_UNIT: json['SERVING_UNIT'].isEmpty ? "미확인" : json['SERVING_UNIT'],
      NUTR_CONT1: json['NUTR_CONT1'].isEmpty ? "미확인" : json['NUTR_CONT1']+' kcal',
      NUTR_CONT2: json['NUTR_CONT2'].isEmpty ? "미확인" : json['NUTR_CONT2']+' g',
      NUTR_CONT3: json['NUTR_CONT3'].isEmpty ? "미확인" : json['NUTR_CONT3']+' g',
      NUTR_CONT4: json['NUTR_CONT4'].isEmpty ? "미확인" : json['NUTR_CONT4']+' g',
      NUTR_CONT5: json['NUTR_CONT5'].isEmpty ? "미확인" : json['NUTR_CONT5']+' g',
      NUTR_CONT6: json['NUTR_CONT6'].isEmpty ? "미확인" : json['NUTR_CONT6']+' mg',
      NUTR_CONT7: json['NUTR_CONT7'].isEmpty ? "미확인" : json['NUTR_CONT7']+' mg',
      NUTR_CONT8: json['NUTR_CONT8'].isEmpty ? "미확인" : json['NUTR_CONT8']+' g',
      NUTR_CONT9: json['NUTR_CONT9'].isEmpty ? "미확인" : json['NUTR_CONT9']+' g',
    );
  }
}





class CustomSearchbar extends StatefulWidget {

  State<CustomSearchbar> createState() => _CustomSearchbar();

}
class _CustomSearchbar extends State<CustomSearchbar> {
  final TextEditingController controller = TextEditingController();
  String? inputText;
  Future<List<Value2>>? list;
   void searchItem() {
     setState(() {
       list = Fetchinfo(inputText);
     });
   }

   Future<List<Value2>> Fetchinfo(String? inputText) async{
     if(inputText == null){
       log('값 받아오기 실패');
       throw Exception('Failed to load data');
     }
     log("받은 검색의 값${inputText}");
     log('새로운 api');
     var url = "http://openapi.foodsafetykorea.go.kr/api"; //sample/I2790/xml/1/5/DESC_KOR=값 &RESEARCH_YEAR=값 &MAKER_NAME=값 &FOOD_CD=값 &CHNG_DT=값";
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
       List<Value2> allInfo = item.map((dynamic items) => Value2.fromJson(items)).toList();
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

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          SearchBar(
              hintText: "음식명을 입력하세요",
              controller: controller,
              trailing: [
                IconButton(
                  icon: const Icon(Icons.keyboard_voice),
                  onPressed: () {
                    print('Use voice command');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    print('Use image search');
                  },
                ),
              ],
              onSubmitted: (value) {
                inputText = value;
                searchItem();
              },
            ),
          //SizedBox(height: 15.0),
          Expanded(
              child: FutureBuilder<List<Value2>>(
                future: list, // Future<List<Value>> 타입의 Future
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // 로딩 중 표시
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString()); // 에러 발생 시
                  } else if (snapshot.hasData) {
                    // 데이터가 정상적으로 로드되었을 때
                    // 데이터를 사용하여 UI를 구성
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical, // 상하 스크롤 활성화
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // 좌우 스크롤 활성화
                        child: searchValue(snapshot, snapshot.data!.length)
                      ),
                    );
                  } else {
                    return Text("데이터가 없습니다."); // 데이터가 없을 때
                  }
                },
              ),
          )


        ],

      );
    }

    DataTable searchValue(AsyncSnapshot<List<Value2>> snapshot, int index){
     return DataTable(
       border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey,width: 1)),
       columnSpacing: 10.0,
       columns: const [
         DataColumn(label: Text('이름')),
         DataColumn(label: Text('업체명')),
         DataColumn(label: Text('열량')),
         DataColumn(label: Text('탄수화물')),
         DataColumn(label: Text('단백질')),
         DataColumn(label: Text('지방')),
         DataColumn(label: Text('당류')),
         DataColumn(label: Text('나트륨')),
         DataColumn(label: Text('콜레스테롤')),
         DataColumn(label: Text('포화지방산')),
         DataColumn(label: Text('트랜스지방')),
       ],
       rows: List<DataRow>.generate(
         snapshot.data!.length,
             (index) => DataRow(
           cells: [
             DataCell(Text(snapshot.data![index].DESC_KOR)),
             DataCell(Text(snapshot.data![index].MAKER_NAME)),
             DataCell(Center(child: Text(snapshot.data![index].NUTR_CONT1))),
             DataCell(Center(child: Text(snapshot.data![index].NUTR_CONT2))),
             DataCell(Center(child: Text(snapshot.data![index].NUTR_CONT3))),
             DataCell(Center(child: Text(snapshot.data![index].NUTR_CONT4))),
             DataCell(Center(child: Text(snapshot.data![index].NUTR_CONT5))),
             DataCell(Center(child: Text(snapshot.data![index].NUTR_CONT6))),
             DataCell(Center(child: Text(snapshot.data![index].NUTR_CONT7))),
             DataCell(Center(child: Text(snapshot.data![index].NUTR_CONT8))),
             DataCell(Center(child: Text(snapshot.data![index].NUTR_CONT9))),
           ],
         ),
       ),
     );
    }

}



//ListView.builder(
//shrinkWrap: true,
//itemCount: snapshot.data!.length,
//itemBuilder: (context, index) {
//return Column(
//children: [
//Text("이름: "+ snapshot.data![index].DESC_KOR + "  "),
//Text("열량: " + snapshot.data![index].NUTR_CONT1 + "kcal  "),
//Text("탄수화물: " + snapshot.data![index].NUTR_CONT2 + "g  "),
//Text("단백질: " + snapshot.data![index].NUTR_CONT3 + "g  "),
//Text("지방: " + snapshot.data![index].NUTR_CONT4 + "g  "),
//Text("당류: " + snapshot.data![index].NUTR_CONT5 + "g  "),
//Text("나트륨: " + snapshot.data![index].NUTR_CONT6 + "mg  "),
//Text("콜레스테롤: " + snapshot.data![index].NUTR_CONT7 + "mg  "),
//Text("포화지방산: " + snapshot.data![index].NUTR_CONT8 + "g  "),
//Text("트랜스자방산: " + snapshot.data![index].NUTR_CONT9 + "g  "),
// 이하 생략
//],
//);
