import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoea/models/transaction_model.dart';
import 'package:shoea/service/internet_service.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/constants.dart';

class TransactionRepository{
  Future<void> addToTransaction(String transactionID, int shoeID, String color, int size, int qty, int price, String payment, DateTime now)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.transactionID : transactionID,
        Constants.shoeID : shoeID,
        Constants.color : color,
        Constants.size : size,
        Constants.qty : qty,
        Constants.price : price,
        Constants.payment : payment,
        Constants.createdAt : now.toIso8601String()
      });

      await InternetService.dio.post("/auth/add-to-transaction",
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

  Future<List<TransactionModel>> getAllTransaction()async{
    try{
      final response = await InternetService.dio.get("/auth/get-all-transaction",
        options: Options(
          headers: {
            Constants.accept : Constants.appJson,
            HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
          }
        )
      );

      if(response.statusCode == 200){
        final datas = response.data as List;
        final list = datas.map((data) => TransactionModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }
}