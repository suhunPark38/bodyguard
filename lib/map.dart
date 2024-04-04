import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

Future<Widget> MapRun() async {
  await _initialize();
  return const NaverMapApp();
}


// 지도 초기화하기
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'yrgpw62fjk',     // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed")

  );
}








class NaverMapApp extends StatelessWidget {
  const NaverMapApp({Key? key});


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
                options: NaverMapViewOptions(initialCameraPosition: NCameraPosition(target: NLatLng(37.506932467450326, 127.05578661133796), zoom: 14)),

                onMapReady: (controller) {

                  //id: 고유값,position: NLatLng(좌표값)
                  final marker = NMarker(
                      id: 'test',
                      position: const NLatLng(37.506932467450326, 127.05578661133796));

                  final marker1 = NMarker(
                      id: 'test1',
                      position: const NLatLng(37.606932467450326, 127.05578661133796)

                  );



                  final onMarkerInfoWindow =
                  NInfoWindow.onMarker(id: marker.info.id, text: "멋쟁이 사자처럼");

                  controller.addOverlayAll({marker, marker1});
                  marker.openInfoWindow(onMarkerInfoWindow);
                },
                onMapTapped: (point, latLng) {
                  debugPrint("${latLng.latitude}、${latLng.longitude}");
                },
              ),
            ),
            DraggableScrollableSheet(
              // 화면 비율로 높이 조정
              expand: true,
              initialChildSize: 0.1,
              minChildSize: 0.1,
              maxChildSize: 0.8,

              builder: (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    child: Expanded(
                      child: Text("가게정보",textAlign: TextAlign.center,),
                    ),
                    height: 1000,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)
                        ),
                        color: Colors.white
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
//출처: https://daino.tistory.com/entry/플러터Flutter-네이버지도Navermap-마커-생성-위젯-사용 [daino_saur:티스토리]
}
