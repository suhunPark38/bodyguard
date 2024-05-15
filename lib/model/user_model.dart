import 'dart:developer';

class UserInfoModel{
  final String nickName;
  final String email;
  final String gender;
  final double height;
  final double weight;
  final int age;

  UserInfoModel({
    required this.nickName,
    required this.email,
    required this.height,
    required this.weight,
    required this.age,
    required this.gender
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoModel &&
          runtimeType == other.runtimeType &&
          nickName == other.nickName &&
          email == other.email &&
          height == other.height &&
          weight == other.weight &&
          age == other.age &&
          gender == other.gender;

  @override
  int get hashCode =>
      nickName.hashCode ^
      email.hashCode ^
      height.hashCode ^
      weight.hashCode ^
      age.hashCode ^
      gender.hashCode;

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

    if (json == null) {
      throw ArgumentError("json data is null");
    }
    final nickName = json["nickName"];
    final email = json["email"];
    final height = getDoubleValue("height");
    final weight = getDoubleValue("weight");
    final age = getIntValue("age");
    final gender = json["gender"];



    log("user_model의 factory UserInfo.fromJson 출력 값: "
        "$nickName $email $height $weight $age $gender");

    return UserInfoModel(
      nickName: nickName,
      email: email,
      height: height,
      weight: weight,
      age: age,
      gender: gender,

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

    };
  }


}