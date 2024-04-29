import 'dart:developer';

class Store {
  final String id;
  final String StoreName;
  final double latitude;
  final double longitude;
  final String subscript;

  Store({
    required this.id,
    required this.StoreName,
    required this.subscript,
    required this.latitude,
    required this.longitude,
  });

  factory Store.fromJson(String id,Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("json data is null");
    }
    final StoreName = json["storeName"];
    final subscript = json["subscript"];
    final latitude = (json["latitude"] ?? 0).toDouble();
    final longitude = (json["longitude"] ?? 0).toDouble();

    log("받은 값: $id $StoreName $subscript $latitude $longitude");

    return Store(
      id: id,
      StoreName: StoreName,
      subscript: subscript,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "storeName": StoreName,
      "subscript": subscript,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
