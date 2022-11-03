import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoea/models/address_model.dart';
import 'package:shoea/models/ongkir/city_model.dart';
import 'package:shoea/models/ongkir/province_model.dart';
import 'package:shoea/service/internet_service.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/constants.dart';

class AddressRepository{
  Future<List<ProvinceModel>> getAllProvince()async{
    try{
      final response = await InternetService.dio.get("https://api.rajaongkir.com/starter/province",
        options: Options(
          headers: {
            Constants.key : Constants.ongkirApiKey
          }
        )
      );

      if(response.statusCode == 200){
        final datas = response.data[Constants.rajaOngkir][Constants.results] as List;
        final list = datas.map((data) => ProvinceModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<CityModel>> getAllCityById(String provinceID)async{
    try{
      final response = await InternetService.dio.get("https://api.rajaongkir.com/starter/city?province=$provinceID",
          options: Options(
              headers: {
                Constants.key : Constants.ongkirApiKey
              }
          )
      );

      if(response.statusCode == 200){
        final datas = response.data[Constants.rajaOngkir][Constants.results] as List;
        final list = datas.map((data) => CityModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> addAddress(String provinceID, String cityID, double lat, double lng, String addressName, String addressDetail)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.provinceID : provinceID,
        Constants.cityID : cityID,
        Constants.lat : lat,
        Constants.lng : lng,
        Constants.addressName : addressName,
        Constants.addressDetail : addressDetail
      });

      await InternetService.dio.post("/auth/add-address",
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

  Future<List<AddressModel>> getAllAddress()async{
    try{
      final response = await InternetService.dio.get("/auth/get-all-address",
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        final datas = response.data as List;
        final list = datas.map((data) => AddressModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<AddressModel> getDefaultAddress()async{
    try{
      final response = await InternetService.dio.get("/auth/get-default-address",
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        return AddressModel.fromJson(response.data);
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> changeDefaultAddress(int id)async{
    try{
      await InternetService.dio.put("/auth/change-default-address/$id",
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

  Future<void> updateAddress(int id, String provinceID, String cityID, String addressName, String addressDetail)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.provinceID : provinceID,
        Constants.cityID : cityID,
        Constants.addressName : addressName,
        Constants.addressDetail : addressDetail
      });

      await InternetService.dio.put("/auth/update-address/$id",
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