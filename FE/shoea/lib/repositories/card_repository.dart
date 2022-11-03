import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoea/models/card_model.dart';
import 'package:shoea/service/internet_service.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/constants.dart';

class CardRepository{
  Future<void> addCard(String bankName, String number, String expiredDate, String cvv, String cardHolder)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.bankName : bankName,
        Constants.number : number,
        Constants.expired : expiredDate,
        Constants.cvv : cvv,
        Constants.holder : cardHolder
      });
      
      await InternetService.dio.post("/auth/add-card",
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

  Future<List<CardModel>> getAllCard()async{
    try{
      final response = await InternetService.dio.get("/auth/get-all-card",
        options: Options(
          headers: {
            Constants.accept : Constants.appJson,
            HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
          }
        )
      );

      if(response.statusCode == 200){
        final datas = response.data as List;
        final list = datas.map((data) => CardModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<CardModel> getDefaultCard()async{
    try{
      final response = await InternetService.dio.get("/auth/get-default-card",
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        return CardModel.fromJson(response.data);
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> changeDefaultCard(int id)async{
    try{
      await InternetService.dio.put("/auth/change-default-card/$id",
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