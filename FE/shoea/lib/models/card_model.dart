// To parse this JSON data, do
//
//     final cardModel = cardModelFromJson(jsonString);

import 'dart:convert';

CardModel cardModelFromJson(String str) => CardModel.fromJson(json.decode(str));

String cardModelToJson(CardModel data) => json.encode(data.toJson());

class CardModel {
  CardModel({
    this.id,
    this.userId,
    this.bankName,
    this.number,
    this.expiredDate,
    this.cvv,
    this.cardHolder,
    this.isDefault,
  });

  int? id;
  int? userId;
  String? bankName;
  String? number;
  String? expiredDate;
  String? cvv;
  String? cardHolder;
  bool? isDefault;

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    id: json["id"],
    userId: json["user_id"],
    bankName: json["bank_name"],
    number: json["number"],
    expiredDate: json["expired_date"],
    cvv: json["cvv"],
    cardHolder: json["card_holder"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "bank_name": bankName,
    "number": number,
    "expired_date": expiredDate,
    "cvv": cvv,
    "card_holder": cardHolder,
    "is_default": isDefault,
  };
}
