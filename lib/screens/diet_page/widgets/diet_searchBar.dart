import 'dart:async';
import 'package:flutter/material.dart';
import '../../../model/fetched_diet_data.dart';
import 'diet_input_dialog.dart';
import 'package:bodyguard/utils/diet_util.dart'; // 가정한 경로입니다.

class CustomSearchbar extends StatefulWidget {
  State<CustomSearchbar> createState() => _CustomSearchbarState();
}

class _CustomSearchbarState extends State<CustomSearchbar> {
  final TextEditingController controller = TextEditingController();
  Future<List<FetchedDietData>>? list;

  void searchItem(String query) {
    setState(() {
      list = DietUtil().Fetchinfo(query); // CamelCase로 수정
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material( // Material 위젯으로 감싸기
              elevation: 5.0, // Shadow 적용
              shadowColor: Colors.grey.withOpacity(0.5), // Shadow 색상
              borderRadius: BorderRadius.circular(30.0), // 모서리 둥글게
              child: TextField(
                controller: controller,
                onChanged: (value) {
                  searchItem(value);
                },
                decoration: InputDecoration(
                  hintText: "음식명을 입력하세요",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // 모서리 둥글게
                  ),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<FetchedDietData>>(
              future: list,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // 로딩 위젯
                } else if (snapshot.hasError) {
                  return Text("데이터가 없습니다");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext builder) {
                              return DietInputDialog(selectedData: snapshot.data![index]);
                            },
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          child: ListTile(
                            title: Text(snapshot.data![index].DESC_KOR, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("${snapshot.data![index].NUTR_CONT1} kcal"),
                            trailing: IconButton(
                              icon: Icon(Icons.info_outline, color: Colors.blue),
                              onPressed: () => _showDietDetail(context, snapshot.data![index]),
                            )
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Text("데이터가 없습니다.");
                }
              },
            ),
          )
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.search),
        backgroundColor: Colors.blueAccent, // FloatingActionButton 색상 변경
      ),*/
    );
  }
}

void _showDietDetail(BuildContext context, FetchedDietData selectedData) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), // 다이얼로그 모서리 둥글게
      title: Text(
        selectedData.DESC_KOR,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20, // 폰트 크기 조정
          color: Colors.blueAccent, // 제목 폰트 색상 변경
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Row(
              children: [
                Icon(Icons.business, color: Colors.deepPurple), // 업체 아이콘 추가
                SizedBox(width: 10), // 아이콘과 텍스트 사이 간격 조정
                Expanded(
                  child: Text('업체명: ${selectedData.MAKER_NAME}',
                      style: TextStyle(fontSize: 16, color: Colors.deepPurple[700])), // 본문 폰트 크기 및 색상 조정
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: Colors.deepPurple[200]), // 구분선 추가
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.fireplace, color: Colors.deepOrange), // 열량 아이콘 추가
                SizedBox(width: 10), // 아이콘과 텍스트 사이 간격 조정
                Expanded(
                  child: Text('열량: ${selectedData.NUTR_CONT1} kcal',
                      style: TextStyle(fontSize: 16, color: Colors.deepOrange[700])), // 본문 폰트 크기 및 색상 조정
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.fastfood, color: Colors.orange), // 탄수화물에 해당하는 아이콘
              title: Text('탄수화물', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
              subtitle: Text('${selectedData.NUTR_CONT2}g', style: TextStyle(fontSize: 14, color: Colors.orange[800])),
            ),
            ListTile(
              leading: Icon(Icons.fitness_center, color: Colors.green), // 단백질에 해당하는 아이콘
              title: Text('단백질', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              subtitle: Text('${selectedData.NUTR_CONT3}g', style: TextStyle(fontSize: 14, color: Colors.green[800])),
            ),
            ListTile(
              leading: Icon(Icons.local_pizza, color: Colors.red), // 지방에 해당하는 아이콘
              title: Text('지방', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
              subtitle: Text('${selectedData.NUTR_CONT4}g', style: TextStyle(fontSize: 14, color: Colors.red[800])),
            ),
            ListTile(
              leading: Icon(Icons.cake, color: Colors.pink), // 당류에 해당하는 아이콘
              title: Text('당류', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink)),
              subtitle: Text('${selectedData.NUTR_CONT5}g', style: TextStyle(fontSize: 14, color: Colors.pink[800])),
            ),
            ListTile(
              leading: Icon(Icons.local_drink, color: Colors.blue), // 나트륨에 해당하는 아이콘
              title: Text('나트륨', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
              subtitle: Text('${selectedData.NUTR_CONT6}mg', style: TextStyle(fontSize: 14, color: Colors.blue[800])),
            ),

          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "닫기",
            style: TextStyle(
              color: Colors.blueAccent, // 버튼 텍스트 색상 변경
              fontWeight: FontWeight.bold, // 버튼 텍스트 굵기 조정
            ),
          ),
        ),
      ],
      backgroundColor: Colors.white, // 다이얼로그 배경색 변경 (필요에 따라 조정)
    ),
  );
}


