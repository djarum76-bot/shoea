// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

import 'package:shoea/models/ongkir/city_model.dart';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.id,
    this.transactionId,
    this.userId,
    this.shoeId,
    this.originCity,
    this.destinationCity,
    this.color,
    this.size,
    this.qty,
    this.price,
    this.payment,
    this.status,
    this.isReviewed,
    this.etd,
    this.shoe,
    this.createdAt,
  });

  int? id;
  int? transactionId;
  int? userId;
  int? shoeId;
  CityModel? originCity;
  CityModel? destinationCity;
  String? color;
  int? size;
  int? qty;
  int? price;
  String? payment;
  String? status;
  bool? isReviewed;
  String? etd;
  Shoe? shoe;
  DateTime? createdAt;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json["id"],
    transactionId: json["transaction_id"],
    userId: json["user_id"],
    shoeId: json["shoe_id"],
    originCity: CityModel.fromJson(json["origin_city"]),
    destinationCity: CityModel.fromJson(json["destination_city"]),
    color: json["color"],
    size: json["size"],
    qty: json["qty"],
    price: json["price"],
    payment: json["payment"],
    status: json["status"],
    isReviewed: json["is_reviewed"],
    etd: json["etd"],
    shoe: Shoe.fromJson(json["shoe"]),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_id": transactionId,
    "user_id": userId,
    "shoe_id": shoeId,
    "origin_city": originCity!.toJson(),
    "destination_city": destinationCity!.toJson(),
    "color": color,
    "size": size,
    "qty": qty,
    "price": price,
    "payment": payment,
    "status": status,
    "is_reviewed": isReviewed,
    "etd": etd,
    "shoe": shoe!.toJson(),
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
