import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoea/models/review_model.dart';
import 'package:shoea/service/internet_service.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/constants.dart';

class ReviewRepository{
  Future<void> addReview(int orderID, int shoeID, double rating, String comment)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.orderID : orderID,
        Constants.shoeID : shoeID,
        Constants.rating : rating,
        Constants.comment : comment,
        Constants.createdAt : DateTime.now().toIso8601String()
      });

      await InternetService.dio.post("/auth/add-review",
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

  Future<List<ReviewModel>> getAllReviewByShoeID(int shoeID)async{
    try{
      final response = await InternetService.dio.get("/auth/get-all-review/$shoeID",
        options: Options(
          headers: {
            Constants.accept : Constants.appJson,
            HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
          }
        )
      );

      if(response.statusCode == 200){
        final datas = response.data as List;
        final list = datas.map((data) => ReviewModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<ReviewModel>> getAllReviewByShoeIDAndRating(int shoeID, String rating)async{
    try{
      final response = await InternetService.dio.get("/auth/get-all-review/$shoeID/$rating",
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        final datas = response.data as List;
        final list = datas.map((data) => ReviewModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }
}