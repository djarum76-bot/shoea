import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shoea/models/cart_model.dart';
import 'package:shoea/service/internet_service.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/constants.dart';

class CartRepository{
  Future<void> addToCart(int shoeID, String color, int size, int qty)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.color : color,
        Constants.size : size,
        Constants.qty : qty
      });

      await InternetService.dio.post("/auth/add-to-cart/$shoeID",
        data: formData,
        options: Options(
          headers: {
            Constants.accept : Constants.appJson,
            HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
          }
        )
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<CartModel>> getAllCarts()async{
    try{
      final response = await InternetService.dio.get("/auth/get-all-carts",
        options: Options(
          headers: {
            Constants.accept : Constants.appJson,
            HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
          }
        )
      );

      if(response.statusCode == 200){
        final datas = response.data as List;
        final list = datas.map((data) => CartModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> deleteCart(int cartID)async{
    try{
      await InternetService.dio.delete("/auth/delete-cart/$cartID",
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> updateQtyCart(int cartID, int qty)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.qty : qty
      });

      await InternetService.dio.put("/auth/update-qty-cart/$cartID",
          data: formData,
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );
    }catch(e){
      throw Exception(e);
    }
  }
}