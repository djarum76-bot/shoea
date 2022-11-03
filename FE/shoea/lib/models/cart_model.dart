// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.id,
    this.userId,
    this.shoeId,
    this.image,
    this.title,
    this.color,
    this.size,
    this.price,
    this.qty,
  });

  int? id;
  int? userId;
  int? shoeId;
  String? image;
  String? title;
  String? color;
  int? size;
  int? price;
  int? qty;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    id: json["id"],
    userId: json["user_id"],
    shoeId: json["shoe_id"],
    image: json["image"],
    title: json["title"],
    color: json["color"],
    size: json["size"],
    price: json["price"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "shoe_id": shoeId,
    "image": image,
    "title": title,
    "color": color,
    "size": size,
    "price": price,
    "qty": qty,
  };
}
