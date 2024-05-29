import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as Math;
import 'package:bodyguard/model/store_model.dart';
import 'package:bodyguard/providers/user_info_provider.dart';
import 'package:bodyguard/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Constants and Globals
final _naverclientid = "yrgpw62fjk";
final _naversecret = "S3EybkJIeurZPmXNmBfhi2j5HwwqrDckAz5Sq2NY";
final _headers = {
  "X-NCP-APIGW-API-KEY-ID": _naverclientid,
  "X-NCP-APIGW-API-KEY": _naversecret,
};

// Map initialization function
Future<void> mapInitialize() async {
  await NaverMapSdk.instance.initialize(
    clientId: _naverclientid,
    onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"),
  );
}

// NaverMapApp Widget
class NaverMapApp extends StatefulWidget {
  const NaverMapApp({super.key});

  @override
  _NaverMapApp createState() => _NaverMapApp();
}

class _NaverMapApp extends State<NaverMapApp> {
  late List<Store> stores;
  ScrollController listScrollController = ScrollController(); // ListView scroll controller
  bool isMapLoading = true; // 로딩 상태를 나타내는 변수
  final Completer<NaverMapController> _controller = Completer<NaverMapController>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInfoProvider>(context);
    return Scaffold(
      body: StreamBuilder<List<Store>>(
        stream: StoreService().getStores(),
        builder: (context, storeSnapshot) {
          if (storeSnapshot.connectionState == ConnectionState.active) {
            if (storeSnapshot.hasData) {
              stores = storeSnapshot.data!;
              return Stack(
                children: [
                  NaverMap(
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: NLatLng(user.info!.NLatLng[1], user.info!.NLatLng[0]),
                        zoom: 18,
                      ),
                    ),
                    onMapReady: (controller) {
                      NMarker marker = NMarker(
                        iconTintColor: Colors.pink,
                        id: "user",
                        position: NLatLng(user.info!.NLatLng[1], user.info!.NLatLng[0]),
                      );
                      controller.addOverlay(marker);
                      final onMarkerInfoWindow = NInfoWindow.onMarker(
                        id: marker.info.id, text: "내 위치",
                      );
                      marker.openInfoWindow(onMarkerInfoWindow);

                      List<NMarker> markers = createMarkersFromStores(stores, controller);
                      for (NMarker marker in markers) {
                        controller.addOverlay(marker);
                        final onMarkerInfoWindow = NInfoWindow.onMarker(
                          id: marker.info.id, text: marker.info.id,
                        );
                        marker.openInfoWindow(onMarkerInfoWindow);
                      }


                      // 네이버 맵 로딩 완료 시 로딩 상태 업데이트
                      _controller.complete(controller);
                      setState(() {
                        isMapLoading = false;
                      });
                    },
                  ),

                  if (isMapLoading) // 로딩 중일 때 인디케이션 표시
                    const Center(child: CircularProgressIndicator()),
                  if (!isMapLoading)
                    DraggableScrollableSheet(
                    expand: true,
                    initialChildSize: 0.1,
                    minChildSize: 0.1,
                    maxChildSize: 0.5,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF80A4B4),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
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
                                    leading: Image.network(
                                      stores[index].image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                    title: Text("${stores[index].storeName}"),
                                    subtitle: Text("${stores[index].subscript}"),
                                    trailing: Column(
                                      children: [
                                        Text("${stores[index].cuisineType}"),
                                        FutureBuilder<String>(
                                          future: calDist(stores[index].latitude, stores[index].longitude, context),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Text('Calculating...');
                                            } else if (snapshot.hasError) {
                                              return Text('Error');
                                            } else {
                                              return Text(snapshot.data ?? 'Unknown distance');
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ShortPathView(
                                            UserNLatLng: NLatLng(user.info!.NLatLng[1], user.info!.NLatLng[0]),
                                            StoreNLatLng: NLatLng(stores[index].latitude, stores[index].longitude),
                                          ),
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
                  ),
                ],
              );
            } else {
              return Center(child: Text("No data available"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  List<NMarker> createMarkersFromStores(List<Store> stores, NaverMapController controller) {
    List<NMarker> markers = [];
    for (int i = 0; i < stores.length; i++) {
      NMarker marker = NMarker(
        id: stores[i].storeName,
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
      double position = index * 80.0; // Adjust according to item height
      listScrollController.animateTo(
        position,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // `didChangeDependencies`에서 조상 위젯 참조
  }


}

// Fetch path using Naver API
Future<List?> searchPath({required NLatLng start, required NLatLng goal}) async {
  var url = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=${start.longitude},${start.latitude}&goal=${goal.longitude},${goal.latitude}&option=trafast";
  Uri uri = Uri.parse(url);
  var response = await http.get(
    uri,
    headers: _headers,
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(utf8.decode(response.bodyBytes));
    if (decodedData['route'] != null && decodedData['route']['trafast'] != null && decodedData['route']['trafast'].isNotEmpty) {
      List<dynamic> path = decodedData['route']['trafast'][0]['path'];
      return path;
    } else {
      print('Path 데이터가 없습니다.');
    }
    return null;
  } else {
    print('값 받아오기 실패');
    log('값 받아오기 실패');
    throw Exception('Failed to load data');
  }
}

// Display Short Path view
Scaffold ShortPathView({required NLatLng UserNLatLng, required NLatLng StoreNLatLng, bool isDelivery = true}) {
  final start = isDelivery ? StoreNLatLng : UserNLatLng;
  final goal = isDelivery ? UserNLatLng : StoreNLatLng;
  return Scaffold(
    body: Stack(
      children: [
        NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: UserNLatLng,
              zoom: 14,
            ),
          ),
          onMapReady: (controller) async {
            NMarker startInfo = NMarker(id: "start", position: start);
            NMarker goalInfo = NMarker(id: "dest", position: goal);
            controller.addOverlayAll({startInfo, goalInfo});
            startInfo.openInfoWindow(NInfoWindow.onMarker(id: startInfo.info.id, text: "출발지"));
            goalInfo.openInfoWindow(NInfoWindow.onMarker(id: goalInfo.info.id, text: "도착지"));

            List? path = await searchPath(start: start, goal: goal);
            List<NLatLng> coords = conversion2NLatLng(path!);
            NPolylineOverlay polyline = NPolylineOverlay(
              coords: coords,
              color: Colors.blue,
              width: 5,
              id: 'null',
            );
            controller.addOverlay(polyline);
          },
        ),
      ],
    ),
  );
}

// Convert dynamic list to NLatLng list
List<NLatLng> conversion2NLatLng(List<dynamic> list) {
  List<NLatLng> path = [];
  for (int i = 0; i < list.length; i++) {
    path.add(NLatLng(list[i][1], list[i][0]));
  }
  return path;
}

// Calculate distance between two points
Future<String> calDist(double lat, double lon, BuildContext context) async {
  NLatLng user = NLatLng(Provider.of<UserInfoProvider>(context).info!.NLatLng[1], Provider.of<UserInfoProvider>(context).info!.NLatLng[0]);
  const earthR = 6371000.0;
  const rad = Math.pi / 180;
  var radLat1 = rad * user.latitude;
  var radLat2 = rad * lat;
  var radDist = rad * (user.longitude - lon);

  var distance = Math.sin(radLat1) * Math.sin(radLat2);
  distance += Math.cos(radLat1) * Math.cos(radLat2) * Math.cos(radDist);
  var ret = earthR * Math.acos(distance);

  if (ret.round() >= 1000) {
    return "${(ret / 1000).toStringAsFixed(2)}km";
  } else {
    return "${ret.toStringAsFixed(2)}m";
  }
}

// Fetch coordinates from address using Naver API
Future<List<Map<String, dynamic>>> fetchCoordinates({
  required String address,
  bool iskor = true,
}) async {
  var uri = Uri.https(
    "naveropenapi.apigw.ntruss.com",
    "/map-geocode/v2/geocode",
    {
      "query": address,
      "language": iskor == true ? "kor" : "eng",
    },
  );
  var response = await http.get(uri, headers: _headers);

  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
    List<dynamic> addresses = responseBody['addresses'];

    if (addresses.isNotEmpty) {
      List<Map<String, dynamic>> coordinatesList = addresses.map((address) {
        return {
          'roadAddress': address['roadAddress'],
          'x': address['x'],
          'y': address['y'],
        };
      }).toList();
      return coordinatesList;
    } else {
      return [];
    }
  } else {
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}
