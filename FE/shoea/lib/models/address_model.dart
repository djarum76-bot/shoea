// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

import 'package:shoea/models/ongkir/city_model.dart';
import 'package:shoea/models/ongkir/province_model.dart';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  AddressModel({
    this.id,
    this.userId,
    this.lat,
    this.lng,
    this.addressName,
    this.province,
    this.city,
    this.addressDetail,
    this.isDefault,
  });

  int? id;
  int? userId;
  double? lat;
  double? lng;
  String? addressName;
  ProvinceModel? province;
  CityModel? city;
  String? addressDetail;
  bool? isDefault;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json["id"],
    userId: json["user_id"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    addressName: json["address_name"],
    province: ProvinceModel.fromJson(json["province"]),
    city: CityModel.fromJson(json["city"]),
    addressDetail: json["address_detail"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "lat": lat,
    "lng": lng,
    "address_name": addressName,
    "province": province!.toJson(),
    "city": city!.toJson(),
    "address_detail": addressDetail,
    "is_default": isDefault,
  };
}