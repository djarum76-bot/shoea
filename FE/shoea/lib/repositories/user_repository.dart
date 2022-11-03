import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoea/models/user_model.dart';
import 'package:shoea/service/internet_service.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/constants.dart';

class UserRepository{
  Future<UserModel> getUser()async{
    try{
      final response = await InternetService.dio.get("/auth/user",
        options: Options(
          headers: {
            Constants.accept : Constants.appJson,
            Constants.authorization : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
          }
        )
      );

      if(response.statusCode == 200){
        return UserModel.fromJson(response.data);
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> fillUserData(String imagePath, String name, String date, String phone, String gender)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.picture : await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
        Constants.name : name,
        Constants.date : date,
        Constants.phone : phone,
        Constants.gender : gender,
      });

      await InternetService.dio.put("/auth/fill-profile",
        data: formData,
        options: Options(
          headers: {
            Constants.accept : Constants.appJson,
            Constants.authorization : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
          }
        )
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> fillUserPin(String pin)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.pin : pin
      });

      await InternetService.dio.put("/auth/fill-pin",
          data: formData,
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                Constants.authorization : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> updatePhoto(String imagePath)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.picture : await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last)
      });

      await InternetService.dio.put("/auth/update-photo",
          data: formData,
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                Constants.authorization : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> updateProfile(String name, String date, String phone, String gender)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.name : name,
        Constants.date : date,
        Constants.phone : phone,
        Constants.gender : gender,
      });

      await InternetService.dio.put("/auth/update-profile",
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