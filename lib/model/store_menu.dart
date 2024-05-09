import 'dart:developer';

class StoreMenu {
  final String id;
  final String storeName; // 추가된 부분: 가게 이름 필드
  final String menuName;
  final String image;
  final int price; // 변경된 부분: double 대신 int를 사용
  final double calories;
  final double carbohydrate;
  final double protein;
  final double fat;
  final double sodium;
  final double sugar;

  StoreMenu({
    required this.id,
    required this.image,
    required this.storeName, // 추가된 부분: 가게 이름 필드
    required this.menuName,
    required this.price, // 변경된 타입
    required this.calories,
    required this.carbohydrate,
    required this.protein,
    required this.fat,
    required this.sodium,
    required this.sugar,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoreMenu &&
        other.id == id &&
        other.storeName == storeName && // 추가된 부분: 가게 이름 필드 비교
        other.menuName == menuName &&
        other.price == price &&
        other.calories == calories &&
        other.carbohydrate == carbohydrate &&
        other.protein == protein &&
        other.fat == fat &&
        other.sodium == sodium &&
        other.sugar == sugar &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    storeName.hashCode ^ // 추가된 부분: 가게 이름 필드 해시
    menuName.hashCode ^
    price.hashCode ^
    calories.hashCode ^
    carbohydrate.hashCode ^
    protein.hashCode ^
    fat.hashCode ^
    sodium.hashCode ^
    sugar.hashCode ^
    image.hashCode;
  }

  factory StoreMenu.fromJson(String Id, Map<String, dynamic>? json) {
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
      var value = json[key];
      if (value == null) throw FormatException("$key 값이 null이거나 존재하지 않습니다.");
      return value is int
          ? value
          : int.tryParse(value.toString()) ??
              (throw FormatException("$key 값을 int로 변환할 수 없습니다."));
    }

    final id = Id;
    final storeName = json["storeName"]; // 변경된 부분: 가게 이름 파싱
    if (storeName == null) {
      throw FormatException("storeName 값이 null이거나 존재하지 않습니다.");
    }
    final image = json["image"];
    if (image == null) {
      throw FormatException("image 값이 null이거나 존재하지 않습니다.");
    }
    final menuName = json["menuName"];
    if (menuName == null) {
      throw FormatException("menuName 값이 null이거나 존재하지 않습니다.");
    }
    final price = getIntValue("price"); // 여기에서 int 값으로 처리
    final calories = getDoubleValue("calories");
    final carbohydrate = getDoubleValue("carbohydrate");
    final protein = getDoubleValue("protein");
    final fat = getDoubleValue("fat");
    final sodium = getDoubleValue("sodium");
    final sugar = getDoubleValue("sugar");

    log("받은 값: $storeName $menuName $price $calories $carbohydrate $protein $fat $sodium $sugar");

    return StoreMenu(
      id: Id,
      storeName: storeName, // 변경된 부분: 가게 이름 할당
      menuName: menuName,
      price: price,
      calories: calories,
      carbohydrate: carbohydrate,
      protein: protein,
      fat: fat,
      sodium: sodium,
      sugar: sugar,
      image: image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "storeName": storeName, // 변경된 부분: 가게 이름 직렬화
      "menuName": menuName,
      "price": price,
      "calories": calories,
      "carbohydrate": carbohydrate,
      "protein": protein,
      "fat": fat,
      "sodium": sodium,
      "sugar": sugar,
      "image": image,
    };
  }
}
