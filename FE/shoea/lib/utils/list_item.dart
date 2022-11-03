import 'package:flutter/material.dart';
import 'package:shoea/models/brand_model.dart';
import 'package:shoea/models/color_model.dart';
import 'package:shoea/models/order_model.dart';
import 'package:simple_icons/simple_icons.dart';

class ListItem{
  static const carouselItems = <String>[
    "asset/carousel/1.jpeg",
    "asset/carousel/2.jpeg",
    "asset/carousel/3.jpeg",
    "asset/carousel/4.jpeg",
    "asset/carousel/5.jpeg",
    "asset/carousel/6.jpeg",
    "asset/carousel/7.jpeg",
  ];

  static const brandItem = <BrandModel>[
    BrandModel(icon: SimpleIcons.adidas, name: "Adidas", id: 1),
    BrandModel(icon: SimpleIcons.nike, name: "Nike", id: 2),
    BrandModel(icon: SimpleIcons.puma, name: "Puma", id: 3),
    BrandModel(icon: SimpleIcons.newbalance, name: "New Balance", id: 4),
    BrandModel(icon: SimpleIcons.reebok, name: "Reebok", id: 5),
    BrandModel(icon: SimpleIcons.jordan, name: "Jordan", id: 6),
  ];

  static const brandChip = <BrandModel>[
    BrandModel(icon: SimpleIcons.adidas, name: "All", id: 0),
    BrandModel(icon: SimpleIcons.adidas, name: "Adidas", id: 1),
    BrandModel(icon: SimpleIcons.nike, name: "Nike", id: 2),
    BrandModel(icon: SimpleIcons.puma, name: "Puma", id: 3),
    BrandModel(icon: SimpleIcons.newbalance, name: "New Balance", id: 4),
    BrandModel(icon: SimpleIcons.reebok, name: "Reebok", id: 5),
    BrandModel(icon: SimpleIcons.jordan, name: "Jordan", id: 6),
  ];

  static const sizeCollection = <int>[39,40,41,42];

  static const colorCollection = <ColorModel>[
    ColorModel(name: "Red", color: Colors.red),
    ColorModel(name: "Yellow", color: Colors.yellow),
    ColorModel(name: "Blue", color: Colors.blue),
    ColorModel(name: "Green", color: Colors.green),
    ColorModel(name: "Black", color: Colors.black),
    ColorModel(name: "Purple", color: Colors.purple),
  ];

  static const ratingCollection = <String>["All", "5", "4", "3", "2", "1"];

  static List<OrderModel> sortOrder(List<OrderModel> orders, String status){
    List<OrderModel> result = <OrderModel>[];
    for(var order in orders){
      if(order.status == status){
        result.add(order);
      }
    }

    return result;
  }
}