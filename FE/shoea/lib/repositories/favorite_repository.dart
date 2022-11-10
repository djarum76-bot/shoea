import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoea/models/favorite_model.dart';
import 'package:shoea/models/shoe_model.dart';
import 'package:shoea/service/internet_service.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/constants.dart';

class FavoriteRepository{
  Future<void> addToFavorite(int shoeID)async{
    try{
      await InternetService.dio.post("/auth/add-to-favorite/$shoeID",
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

  Future<void> deleteFromFavorite(int favoriteID)async{
    try{
      await InternetService.dio.delete("/auth/delete-from-favorite/$favoriteID",
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

  Future<FavoriteModel> getFavorite(int shoeID)async{
    try{
      final response = await InternetService.dio.get("/auth/get-favorite/$shoeID",
        options: Options(
          headers: {
            Constants.accept : Constants.appJson,
            HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
          }
        )
      );

      if(response.statusCode == 200){
        return FavoriteModel.fromJson(response.data);
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<ShoeModel>> getAllFavoriteShoes()async{
    try{
      final response = await InternetService.dio.get("/auth/get-all-favorite-shoes",
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

  Future<List<ShoeModel>> getAllFavoriteShoesByBrand(String brand)async{
    try{
      final response = await InternetService.dio.get("/auth/get-all-favorite-shoes-by-brand/$brand",
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
}