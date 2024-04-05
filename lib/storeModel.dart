import 'dart:developer';

//firebase의 Store의 문서의 필드를 추가하면 이를 추가 및 수정 해야함



class Store {
  final String name;
  final double latitude;
  final double longitude;
  final String subscript;

  Store({required this.name, required this.subscript, required this.latitude, required this.longitude});

  factory Store.fromJson(Map<String, dynamic> json) {
    log(json["name"] + " " + json["subscript"] + " " + json["latitude"].toString() + " " + json["longitude"].toString());

    return Store(
      name: json["name"],
      subscript: json["subscript"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "subscript": subscript,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}