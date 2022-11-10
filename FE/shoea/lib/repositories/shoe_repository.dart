import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoea/models/shoe_model.dart';
import 'package:shoea/service/internet_service.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/constants.dart';

class ShoeRepository{
  Future<List<ShoeModel>> getAllPopularShoes()async{
    try{
      final response = await InternetService.dio.get("/auth/get-all-popular-shoes",
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        final datas = response.data as List;
        final list = datas.map((data) => ShoeModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<ShoeModel>> getAllBrandShoes(String brand)async{
    try{
      final response = await InternetService.dio.get("/auth/get-all-brand-shoes/$brand",
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        final datas = response.data as List;
        final list = datas.map((data) => ShoeModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<ShoeModel>> getAllShoesSearch(String title)async{
    try{
      final response = await InternetService.dio.get('/auth/get-all-shoes-search/$title',
        options: Options(
          headers: {
            Constants.accept : Constants.appJson,
            HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
          }
        )
      );

      if(response.statusCode == 200){
        final datas = response.data as List;
        final list = datas.map((data) => ShoeModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<ShoeModel> getShoe(int id)async{
    try{
      final response = await InternetService.dio.get("/auth/get-shoe/$id",
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        return ShoeModel.fromJson(response.data);
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }
}