import 'dart:developer';

class Store {
  final String name;
  final double latitude;
  final double longitude;
  final String subscript;

  Store({
    required this.name,
    required this.subscript,
    required this.latitude,
    required this.longitude,
  });

  factory Store.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("json data is null");
    }

    final name = json["name"];
    final subscript = json["subscript"];
    final latitude = (json["latitude"] ?? 0).toDouble();
    final longitude = (json["longitude"] ?? 0).toDouble();

    log("$name $subscript $latitude $longitude");

    return Store(
      name: name,
      subscript: subscript,
      latitude: latitude,
      longitude: longitude,
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
