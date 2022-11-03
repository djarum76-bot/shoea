import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoea/utils/constants.dart';

class InternetService{
  static Dio dio = Dio(
    BaseOptions(
      baseUrl: Constants.baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: 600 * 1000,
      receiveTimeout: 600 * 1000,
    )
  );

  static Future<bool> checkUserConnection()async{
    try{
      final result = await InternetAddress.lookup('google.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        return true;
      }
      return false;
    }on SocketException catch(_){
      return false;
    }
  }
}