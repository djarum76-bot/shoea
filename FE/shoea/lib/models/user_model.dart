// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.email,
    this.picture,
    this.name,
    this.date,
    this.phone,
    this.gender,
    this.pin,
  });

  int? id;
  String? email;
  Date? picture;
  Date? name;
  Date? date;
  Date? phone;
  Date? gender;
  Date? pin;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    email: json["email"],
    picture: Date.fromJson(json["picture"]),
    name: Date.fromJson(json["name"]),
    date: Date.fromJson(json["date"]),
    phone: Date.fromJson(json["phone"]),
    gender: Date.fromJson(json["gender"]),
    pin: Date.fromJson(json["pin"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "picture": picture!.toJson(),
    "name": name!.toJson(),
    "date": date!.toJson(),
    "phone": phone!.toJson(),
    "gender": gender!.toJson(),
    "pin": pin!.toJson(),
  };
}

class Date {
  Date({
    this.string,
    this.valid,
  });

  String? string;
  bool? valid;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
    string: json["String"],
    valid: json["Valid"],
  );

  Map<String, dynamic> toJson() => {
    "String": string,
    "Valid": valid,
  };
}
