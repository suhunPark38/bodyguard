import 'dart:developer';

class UserInfoModel {
  final String nickName;
  final String email;
  final String gender;
  final double height;
  final double weight;
  final int age;
  final String roadAddress;
  final String detailAddress;
  final List<double> NLatLng;

  UserInfoModel({
    required this.nickName,
    required this.email,
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.roadAddress,
    required this.NLatLng,
    required this.detailAddress,

  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserInfoModel && runtimeType == other.runtimeType &&
              nickName == other.nickName && email == other.email &&
              gender == other.gender && height == other.height &&
              weight == other.weight && age == other.age &&
              roadAddress == other.roadAddress &&
              detailAddress == other.detailAddress && NLatLng == other.NLatLng;

  @override
  int get hashCode =>
      nickName.hashCode ^
      email.hashCode ^
      gender.hashCode ^
      height.hashCode ^
      weight.hashCode ^
      age.hashCode ^
      roadAddress.hashCode ^
      detailAddress.hashCode ^
      NLatLng.hashCode;


  factory UserInfoModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("json 데이터가 null입니다.");
    }

    double getDoubleValue(String key) {
      var value = json[key];
      if (value == null) throw FormatException("$key 값이 null이거나 존재하지 않습니다.");
      return value is double
          ? value
          : double.tryParse(value.toString()) ??
          (throw FormatException("$key 값을 double로 변환할 수 없습니다."));
    }

    int getIntValue(String key) {
      print("age: ${json[key]}");
      var value = json[key];
      if (value == null) throw FormatException("$key 값이 null이거나 존재하지 않습니다.");
      return value is int
          ? value
          : int.tryParse(value.toString()) ??
          (throw FormatException("$key 값을 int로 변환할 수 없습니다."));
    }

    List<double> getDoubleList(List<dynamic> list) {
      return list.map((item) => double.parse(item.toString())).toList();
    }


    if (json == null) {
      throw ArgumentError("json data is null");
    }
    final nickName = json["nickName"];
    final email = json["email"];
    final height = getDoubleValue("height");
    final weight = getDoubleValue("weight");
    final age = getIntValue("age");
    final gender = json["gender"];
    final roadAddress = json['roadAddress'];
    final NLatLng = getDoubleList(json['NLatLng']);
    final detailAddress = json['DetailAddress'] ?? "";


    log("user_model의 factory UserInfo.fromJson 출력 값: "
        "$nickName $email $height $weight $age $gender");

    return UserInfoModel(
      nickName: nickName,
      email: email,
      height: height,
      weight: weight,
      age: age,
      gender: gender,
      roadAddress: roadAddress,
      detailAddress: detailAddress,
      NLatLng: NLatLng
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nickName": nickName,
      "email": email,
      "height": height,
      "weight": weight,
      "age": age,
      "gender": gender,
      "roadAddress": roadAddress,
      "detailAddress": detailAddress,
      "NLatLng": NLatLng

    };
  }


}