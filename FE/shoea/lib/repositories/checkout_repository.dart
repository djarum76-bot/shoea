import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoea/models/ongkir/shipping_model.dart';
import 'package:shoea/service/internet_service.dart';
import 'package:shoea/utils/constants.dart';

class CheckoutRepository{
  Future<List<ShippingModel>> getShippingType(String destinationCityID)async{
    try{
      var data = {
        Constants.origin : "32",
        Constants.destination : destinationCityID,
        Constants.weight : 100,
        Constants.courier : Constants.jne
      };

      final response = await InternetService.dio.post("https://api.rajaongkir.com/starter/cost",
        data: data,
        options: Options(
          headers: {
            Constants.key : Constants.ongkirApiKey,
            HttpHeaders.contentTypeHeader : Constants.appForm
          }
        )
      );

      if(response.statusCode == 200){
        final dataResults = response.data[Constants.rajaOngkir][Constants.results] as List;
        final dataResult = dataResults[0];
        final dataCosts = dataResult[Constants.costs] as List;
        final list = dataCosts.map((data) => ShippingModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }
}