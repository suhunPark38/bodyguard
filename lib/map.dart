import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bodyguard/model/store_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:bodyguard/model/store_model.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';


import 'package:http/http.dart' as http;


//final storage = FirebaseStorage.instance;
final naverclientid = "yrgpw62fjk";
final naversecret = "S3EybkJIeurZPmXNmBfhi2j5HwwqrDckAz5Sq2NY";


Future<Widget> MapRun() async {
  await _initialize();
  QuerySnapshot<Map<String, dynamic>> snapshot =
  await FirebaseFirestore.instance
      .collection('store')
      .get();
  return NaverMapApp(snapshot);
}




// 지도 초기화하기
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();

  //실수로 새로운 필드 생성함 문제는 없음
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NaverMapSdk.instance.initialize(
      clientId: 'yrgpw62fjk', // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
  // client Secret: S3EybkJIeurZPmXNmBfhi2j5HwwqrDckAz5Sq2NY
}



class NaverMapApp extends StatelessWidget {
  late List<Store> stores;
  ScrollController listScrollController = ScrollController(); // 리스트뷰 스크롤 컨트롤러
  NaverMapApp(QuerySnapshot<Map<String, dynamic>> snapshot, {Key? key})
      : stores = snapshot.docs.map((doc) {
    log("Store Data: ${doc.id}");  // log 함수 사용
    return Store.fromJson(doc.id,doc.data());
  }).toList(),
        super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              child: NaverMap(
                //지도 생성시 초기 위치 조절
                options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                        target: NLatLng(37.58238669765058, 127.0100286533862),
                        zoom: 14)),
                onMapReady: (controller) async {

                  List<NMarker> markers = createMarkersFromStores(stores, controller);
                  for (NMarker marker in markers) {
                    controller.addOverlay(marker);
                    final onMarkerInfoWindow = NInfoWindow.onMarker(
                        id: marker.info.id, text: marker.info.id);
                    marker.openInfoWindow(onMarkerInfoWindow);
                  }

                  //final onMarkerInfoWindow = NInfoWindow.onMarker(id: marker.info.id, text: "멋쟁이 사자처럼");

                  // controller.addOverlayAll({markers.iterator});
                  // marker.openInfoWindow(onMarkerInfoWindow);
                },
                onMapTapped: (point, latLng) {
                  log("내가 클릭한 곳의 좌표${latLng.latitude}、${latLng.longitude}");
                },
              ),
            ),
            DraggableScrollableSheet(
              expand: true,
              initialChildSize: 0.1,
              minChildSize: 0.1,
              maxChildSize: 0.5,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          width: 150,
                          height: 10,
                          margin: EdgeInsets.only(top: 8, bottom: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: listScrollController,
                          itemCount: stores.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(stores[index].StoreName),
                              subtitle: Text('Latitude: ${stores[index].latitude}, Longitude: ${stores[index].longitude}'),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShortPathView(UserNLatLng: const NLatLng(37.58238669765058, 127.0100286533862), StoreNLatLng: NLatLng(stores[index].latitude, stores[index].longitude)), // 받은 Widget으로 화면 전환
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List<NMarker> createMarkersFromStores(List<Store> stores, NaverMapController controller) {
    List<NMarker> markers = [];
    for (int i = 0; i < stores.length; i++) {
      NMarker marker = NMarker(
        id: stores[i].StoreName,
        position: NLatLng(stores[i].latitude, stores[i].longitude),
      );
      marker.setOnTapListener((NMarker marker) {
        print("마커가 터치되었습니다. id: ${marker.info.id}");
        scrollToStore(i);
      });
      markers.add(marker);
    }
    return markers;
  }

  void scrollToStore(int index) {
    if (index < stores.length) {
      double position = index * 80.0; // 예를 들어 각 아이템의 높이가 72.0
      listScrollController.animateTo(
        position,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

//출처: https://daino.tistory.com/entry/플러터Flutter-네이버지도Navermap-마커-생성-위젯-사용 [daino_saur:티스토리]
}

Future<List<Store>> fetchStores() async {
  try {
    // Firestore 인스턴스에서 'store' 컬렉션을 참조하여 문서들을 가져옵니다.
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('store').get();

    // 가져온 문서들을 Store 객체로 변환합니다.
    List<Store> stores = snapshot.docs
        .map((doc) => Store.fromJson(doc.id, doc.data()))
        .toList();

    return stores; // 변환된 Store 객체 리스트를 반환합니다.
  } catch (e) {
    print('Error fetching stores: $e');
    return []; // 오류 발생 시 빈 리스트 반환
  }
}





Future<List?> searchPath({required NLatLng start, required NLatLng goal}) async{
  if(start == null || goal == null){
    log('경로에 대한 좌표 오류');
    throw Exception('Failed to load data');
  }
  log("start=${start.latitude},${start.longitude}&goal=${goal.latitude},${goal.longitude}");
  var url = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=${start.longitude},${start.latitude}&goal=${goal.longitude},${goal.latitude}&option=trafast";
  log(url);
  Uri uri = Uri.parse(url);
  var response = await http.get(uri, headers: <String, String>{
    "X-NCP-APIGW-API-KEY-ID": naverclientid,
    "X-NCP-APIGW-API-KEY": naversecret,
  });
  if (response.statusCode == 200) {
    // Map<String?, dynamic> map = await json.decode(response.body);
    //
    // //log출력을 위한 것
    // final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    // //log(decoded.toString());
    // Map<String?, dynamic> body = map['route'];
    // Map<String?, dynamic> item = body['trafast'];
    // print(body);
    var decodedData = jsonDecode(utf8.decode(response.bodyBytes));

    // 'route' -> 'trafast' 배열 첫 번째 요소의 'path' 키에 접근
    if (decodedData['route'] != null && decodedData['route']['trafast'] != null && decodedData['route']['trafast'].isNotEmpty) {
      List<dynamic> path = decodedData['route']['trafast'][0]['path'];
      return path;
    } else {
      print('Path 데이터가 없습니다.');
    }
    return null;
    //List<NLatLng> pathlist = d

  } else {
    // 오류 처리 또는 빈 리스트 반환
    print('값 받아오기 실패');
    log('값 받아오기 실패');
    throw Exception('Failed to load data');
  }

}



//지도에 출발지 도착지 표시
MaterialApp ShortPathView({required NLatLng UserNLatLng, required NLatLng StoreNLatLng, bool isDelivery = true}){
  final start = isDelivery ? StoreNLatLng : UserNLatLng;
  final goal = isDelivery ? UserNLatLng : StoreNLatLng;
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Stack(
        children: [
          Container(
            child: NaverMap(
              //지도 생성시 초기 위치 조절
                options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                        target: UserNLatLng,
                        zoom: 14)),
                onMapReady: (controller) async {
                  NMarker startInfo = NMarker(id: "start", position: start);
                  NMarker goalInfo = NMarker(id: "dest", position: goal);
                  controller.addOverlayAll({startInfo, goalInfo});
                  startInfo.openInfoWindow(
                      NInfoWindow.onMarker(id: startInfo.info.id, text: "출발지"));
                  goalInfo.openInfoWindow(
                      NInfoWindow.onMarker(id: goalInfo.info.id, text: "도착지"));

                  List? path = await searchPath(start: start, goal: goal);
                  List<NLatLng> coords = conversion2NLatLng(path!);
                  NPolylineOverlay a = NPolylineOverlay(
                    coords: coords,
                    color: Colors.blue, // 경로의 색상
                    width: 5, // 경로의 너비
                    id: 'null',
                  );
                  controller.addOverlay(a);
                }
            ),
          ),
        ],
      ),
    ),
  );
}

List<NLatLng> conversion2NLatLng(List<dynamic> list){
  List<NLatLng> path = [];
  for (int i = 0; i < list.length; i++){
    path.add(NLatLng(list[i][1], list[i][0]));
  }
  return path;
}

