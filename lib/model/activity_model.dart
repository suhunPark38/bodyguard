import 'dart:developer';

class Activity {
  final String id;
  final String icon;
  final double burn;

  Activity({
    required this.id,
    required this.icon,
    required this.burn,
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Activity &&
        other.id == id &&
        other.icon == icon &&
        other.burn == burn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    icon.hashCode ^
    burn.hashCode;
  }
  factory Activity.fromJson(String id,Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("json data is null");
    }
    final icon = json["icon"];
    final burn;

    if (json["burn"] == null) {
      throw FormatException("burn 값이 null이거나 존재하지 않습니다.");
    } else {
      double? parsedValue = double.tryParse(json["burn"].toString());
      if (parsedValue == null) {
        throw FormatException("burn 값을 double로 변환할 수 없습니다.");
      }
      burn = parsedValue;
      return Activity(
        id: id,
        icon: icon,
        burn: burn,
      );
    }
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "icon": icon,
      "burn": burn,
    };
  }
}
