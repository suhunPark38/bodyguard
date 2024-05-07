import 'dart:developer';

class Store {
  final String id;
  final String storeName;
  final double latitude;
  final double longitude;
  final String subscript;
  final String image;
  final String cuisineType;

  Store({
    required this.id,
    required this.storeName,
    required this.subscript,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.cuisineType
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Store &&
        other.id == id &&
        other.storeName == storeName &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.subscript == subscript &&
        other.image == image &&
        other.cuisineType == cuisineType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    storeName.hashCode ^
    latitude.hashCode ^
    longitude.hashCode ^
    subscript.hashCode ^
    image.hashCode ^
    cuisineType.hashCode;
  }
  factory Store.fromJson(String id,Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("json data is null");
    }
    final storeName = json["storeName"];
    final subscript = json["subscript"];
    final latitude = (json["latitude"] ?? 0).toDouble();
    final longitude = (json["longitude"] ?? 0).toDouble();
    final image = json["image"];
    final cuisineType = json["cuisineType"];
    log("받은 값: $id $storeName $subscript $latitude $longitude");

    return Store(
      id: id,
      storeName: storeName,
      subscript: subscript,
      latitude: latitude,
      longitude: longitude,
      image: image,
      cuisineType: cuisineType,
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
