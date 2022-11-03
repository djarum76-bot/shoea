// To parse this JSON data, do
//
//     final shippingModel = shippingModelFromJson(jsonString);

import 'dart:convert';

ShippingModel shippingModelFromJson(String str) => ShippingModel.fromJson(json.decode(str));

String shippingModelToJson(ShippingModel data) => json.encode(data.toJson());

class ShippingModel {
  ShippingModel({
    this.service,
    this.description,
    this.cost,
  });

  String? service;
  String? description;
  List<Cost>? cost;

  factory ShippingModel.fromJson(Map<String, dynamic> json) => ShippingModel(
    service: json["service"],
    description: json["description"],
    cost: List<Cost>.from(json["cost"].map((x) => Cost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "service": service,
    "description": description,
    "cost": List<dynamic>.from(cost!.map((x) => x.toJson())),
  };
}

class Cost {
  Cost({
    this.value,
    this.etd,
    this.note,
  });

  int? value;
  String? etd;
  String? note;

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
    value: json["value"],
    etd: json["etd"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "etd": etd,
    "note": note,
  };
}
