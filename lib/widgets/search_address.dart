import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;

import '../map.dart';

class SearchAddress extends StatefulWidget {
  @override
  _SearchAddressState createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  TextEditingController controller = TextEditingController();
  List<dynamic> list = [];
  int currentPage = 1; // 현재 페이지 번호
  bool isLoading = false; // 요청 중인지 여부

  List<Map<String, dynamic>> coordinates = [];

  final String _naverclientid = 'YOUR_CLIENT_ID';
  final String _naversecret = 'YOUR_CLIENT_SECRET';

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("주소 검색"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: '주소를 입력하세요',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          setState(() {
                            list = [];
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isLoading ? null : () {
                    setState(() {
                      currentPage = 1;
                    });
                    fetchAddresses(1);
                  },
                  child: Text("검색"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildAddressList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: currentPage > 1 && !isLoading ? () => fetchAddresses(currentPage - 1) : null,
                ),
                Text('페이지 $currentPage'),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: (list.length == 10 && !isLoading) ? () => fetchAddresses(currentPage + 1) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void fetchAddresses(int page) {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> params = {
        "confmKey": "devU01TX0FVVEgyMDI0MDUxNzE2MDcwNzExNDc3Mzg=",
        "currentPage": page.toString(),
        "countPerPage": "10",
        "keyword": controller.text,
        'resultType': "json",
      };
      http
          .post(
        Uri.parse("https://business.juso.go.kr/addrlink/addrLinkApi.do"),
        body: params,
      )
          .then((response) {
        var json = jsonDecode(response.body);
        setState(() {
          list = json['results']['juso'];
          currentPage = page;
          isLoading = false;
        });
      })
          .catchError((error) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Widget _buildAddressList() {
    return Expanded(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : list.isNotEmpty
          ? ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${list[index]['roadAddrPart1']} ${list[index]['roadAddrPart2']}'),
            subtitle: Text('[우편번호: ${list[index]['zipNo']}]'),
            leading: IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () async {
                coordinates = await fetchCoordinates(list[index]['roadAddrPart1']);
                if (coordinates is List) {
                  showMapDialog(context, coordinates[0]);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('좌표를 가져오지 못했습니다.')));
                }
              },
            ),
            onTap: () async {  // ListTile 전체에 클릭 이벤트 추가
              coordinates = await fetchCoordinates(list[index]['roadAddrPart1']);
              if(coordinates.isNotEmpty){
                print(coordinates[0]['x']);
                Navigator.pop(context, coordinates[0]);
                }
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: list.length,
      )
          : Center(
        child: Text('검색 결과가 없습니다.'),
      ),
    );
  }




  void showMapDialog(BuildContext context, dynamic coordinate) {
    NLatLng coordin = NLatLng(
        double.parse(coordinate['y']),
        double.parse(coordinate['x']),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("지도 보기"),
          content: Container(
            height: 300, // 지도의 높이를 조절
            width: 300, // 지도의 너비를 조절
            child: NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: coordin, zoom: 16
                )
              ),
              onMapReady: (controller) {
                NMarker marker = NMarker(
                  iconTintColor: Colors.pink,
                  id: "user",
                  position: coordin,
                );
                controller.addOverlay(marker);
                final onMarkerInfoWindow = NInfoWindow.onMarker(
                  id: marker.info.id, text: "내 위치",
                );
                marker.openInfoWindow(onMarkerInfoWindow);
              },
              ),
            ),
        );
      },
    );
  }
}
//호명로