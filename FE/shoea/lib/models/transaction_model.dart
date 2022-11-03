// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());

class TransactionModel {
  TransactionModel({
    this.id,
    this.transactionId,
    this.userId,
    this.shoeId,
    this.color,
    this.size,
    this.qty,
    this.price,
    this.shoe,
    this.payment,
    this.createdAt,
  });

  int? id;
  int? transactionId;
  int? userId;
  int? shoeId;
  String? color;
  int? size;
  int? qty;
  int? price;
  Shoe? shoe;
  String? payment;
  DateTime? createdAt;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id: json["id"],
    transactionId: json["transaction_id"],
    userId: json["user_id"],
    shoeId: json["shoe_id"],
    color: json["color"],
    size: json["size"],
    qty: json["qty"],
    price: json["price"],
    shoe: Shoe.fromJson(json["shoe"]),
    payment: json["payment"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_id": transactionId,
    "user_id": userId,
    "shoe_id": shoeId,
    "color": color,
    "size": size,
    "qty": qty,
    "price": price,
    "shoe": shoe!.toJson(),
    "payment": payment,
    "created_at": createdAt!.toIso8601String(),
  };
}

class Shoe {
  Shoe({
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
  int? rating;
  int? review;
  String? description;
  dynamic sizes;
  dynamic colors;
  int? price;

  factory Shoe.fromJson(Map<String, dynamic> json) => Shoe(
    id: json["id"],
    brand: json["brand"],
    image: json["image"],
    title: json["title"],
    sold: json["sold"],
    rating: json["rating"],
    review: json["review"],
    description: json["description"],
    sizes: json["sizes"],
    colors: json["colors"],
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
    "sizes": sizes,
    "colors": colors,
    "price": price,
  };
}
