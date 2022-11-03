// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

import 'package:shoea/models/user_model.dart';

ReviewModel reviewModelFromJson(String str) => ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  ReviewModel({
    this.id,
    this.user,
    this.orderId,
    this.shoeId,
    this.rating,
    this.comment,
    this.createdAt,
  });

  int? id;
  UserModel? user;
  int? orderId;
  int? shoeId;
  double? rating;
  String? comment;
  DateTime? createdAt;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json["id"],
    user: UserModel.fromJson(json["user"]),
    orderId: json["order_id"],
    shoeId: json["shoe_id"],
    rating: json["rating"].toDouble(),
    comment: json["comment"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user!.toJson(),
    "order_id": orderId,
    "shoe_id": shoeId,
    "rating": rating,
    "comment": comment,
    "created_at": createdAt!.toIso8601String(),
  };
}