import 'dart:developer';

class Store {
  final String id;
  final String storeName;
  final double latitude;
  final double longitude;
  final String subscript;

  Store({
    required this.id,
    required this.storeName,
    required this.subscript,
    required this.latitude,
    required this.longitude,
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Store &&
        other.id == id &&
        other.storeName == storeName &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.subscript == subscript;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    storeName.hashCode ^
    latitude.hashCode ^
    longitude.hashCode ^
    subscript.hashCode;
  }
  factory Store.fromJson(String id,Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("json data is null");
    }
    final storeName = json["storeName"];
    final subscript = json["subscript"];
    final latitude = (json["latitude"] ?? 0).toDouble();
    final longitude = (json["longitude"] ?? 0).toDouble();

    log("받은 값: $id $storeName $subscript $latitude $longitude");

    return Store(
      id: id,
      storeName: storeName,
      subscript: subscript,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "storeName": storeName,
      "subscript": subscript,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
