// To parse this JSON data, do
//
//     final shoeModel = shoeModelFromJson(jsonString);

import 'dart:convert';

ShoeModel shoeModelFromJson(String str) => ShoeModel.fromJson(json.decode(str));

String shoeModelToJson(ShoeModel data) => json.encode(data.toJson());

class ShoeModel {
  ShoeModel({
    this.id,
    this.brand,
    this.image,
    this.title,
    this.sold,
    this.rating,
    this.review,
    this.description,
    this.sizes,
    this.colors,
    this.price,
  });

  int? id;
  String? brand;
  String? image;
  String? title;
  int? sold;
  double? rating;
  int? review;
  String? description;
  List<Size>? sizes;
  List<String>? colors;
  int? price;

  factory ShoeModel.fromJson(Map<String, dynamic> json) => ShoeModel(
    id: json["id"],
    brand: json["brand"],
    image: json["image"],
    title: json["title"],
    sold: json["sold"],
    rating: json["rating"].toDouble(),
    review: json["review"],
    description: json["description"],
    sizes: List<Size>.from(json["sizes"].map((x) => Size.fromJson(x))),
    colors: List<String>.from(json["colors"].map((x) => x)),
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand": brand,
    "image": image,
    "title": title,
    "sold": sold,
    "rating": rating,
    "review": review,
    "description": description,
    "sizes": List<dynamic>.from(sizes!.map((x) => x.toJson())),
    "colors": List<dynamic>.from(colors!.map((x) => x)),
    "price": price,
  };
}

class Size {
  Size({
    this.int64,
    this.valid,
  });

  int? int64;
  bool? valid;

  factory Size.fromJson(Map<String, dynamic> json) => Size(
    int64: json["Int64"],
    valid: json["Valid"],
  );

  Map<String, dynamic> toJson() => {
    "Int64": int64,
    "Valid": valid,
  };
}
