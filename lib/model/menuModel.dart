class Menu {
  final String foodName;
  final double price;

  Menu({required this.foodName, required this.price});

  factory Menu.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("json data is null");
    }

    final foodName = json["foodName"];
    final price = json["price"];


    return Menu(
      foodName: foodName,
      price: price,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "foodName": foodName,
      "price" : price,
    };
  }

}
