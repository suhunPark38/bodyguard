import 'dart:async';
import 'package:bodyguard/utils/diet_util.dart';
import 'package:flutter/material.dart';


import '../../../model/fetched_diet_data.dart';
import 'diet_input_dialog.dart';

class CustomSearchbar extends StatefulWidget {
  State<CustomSearchbar> createState() => _CustomSearchbar();
}

class _CustomSearchbar extends State<CustomSearchbar> {
  final TextEditingController controller = TextEditingController();
  String? inputText;
  Future<List<FetchedDietData>>? list;

  void searchItem() {
    setState(() {
      list = DietUtil().Fetchinfo(inputText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          onSubmitted: (value) {
            inputText = value;
            searchItem();
          },
          decoration: InputDecoration(
            hintText: "음식명을 입력하세요",
          ),
        ),
        //SizedBox(height: 15.0),
        Expanded(
          child: FutureBuilder<List<FetchedDietData>>(
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
                      child: searchValue(snapshot, snapshot.data!.length)),
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

  DataTable searchValue(AsyncSnapshot<List<FetchedDietData>> snapshot, int index) {
    return DataTable(
      border: TableBorder.symmetric(
          inside: BorderSide(color: Colors.grey, width: 1)),
      columnSpacing: 10.0,
      columns: const [
        DataColumn(label: Text('이름')),
        DataColumn(label: Text('열량')),
        DataColumn(label: Text('상세 보기')),
        DataColumn(label: Text('선택')),
      ],
      rows: List<DataRow>.generate(
        snapshot.data!.length,
        (index) => DataRow(
          cells: [
            DataCell(Text(snapshot.data![index].DESC_KOR)),
            DataCell(Center(child: Text(snapshot.data![index].NUTR_CONT1))),
            DataCell(IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _showDietDetail(context, snapshot.data![index]),
            )),
            DataCell(
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext builder) {
                    return DietInputDialog(selectedData: snapshot.data![index]);
                  },
                ),
                child: const Text('선택'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showDietDetail(BuildContext context, FetchedDietData selectedData) {

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(selectedData.DESC_KOR),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('업체명'),
                    subtitle: Text(selectedData.MAKER_NAME),
                  ),
                  ListTile(
                    title: Text('열량'),
                    subtitle: Text('${selectedData.NUTR_CONT1}kcal'),

                  ),
                  ListTile(
                    title: Text('탄수화물'),
                    subtitle: Text('${selectedData.NUTR_CONT2}g'),
                  ),
                  ListTile(
                    title: Text('단백질'),
                    subtitle: Text('${selectedData.NUTR_CONT3}g'),
                  ),
                  ListTile(
                    title: Text('지방'),
                    subtitle: Text('${selectedData.NUTR_CONT4}g'),
                  ),
                  ListTile(
                    title: Text('당류'),
                    subtitle: Text('${selectedData.NUTR_CONT5}g'),
                  ),
                  ListTile(
                    title: Text('나트륨'),
                    subtitle: Text('${selectedData.NUTR_CONT6}mg'),
                  ),
                  /*ListTile(
                    title: Text('콜레스테롤'),
                    subtitle: Text('${selectedData.NUTR_CONT7}mg'),
                  ),
                  ListTile(
                    title: Text('포화지방산'),
                    subtitle: Text('${selectedData.NUTR_CONT8}g'),
                  ),
                  ListTile(
                    title: Text('트랜스지방'),
                    subtitle: Text('${selectedData.NUTR_CONT9}g'),
                  ),*/
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("닫기"))
            ],
          ));
}

