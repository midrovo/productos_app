import 'dart:convert';

class Product {
  bool available;
  String name;
  String? picture;
  double price;
  String? id;

  Product({
    required this.available,
    required this.name,
    this.picture,
    required this.price,
    this.id
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    available: json["available"],
    name: json["name"],
    picture: json["picture"],
    price: json["price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "available": available,
    "name": name,
    "picture": picture,
    "price": price,
  };

  Product copy() => Product(
    available: available,
    name: name,
    picture: picture,
    price: price,
    id: id
  );
}
