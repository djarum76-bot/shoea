import 'dart:io';

import 'package:admin/utils/constants.dart';
import 'package:dio/dio.dart';

class InternetService{
  static Dio dio = Dio(
      BaseOptions(
          baseUrl: Constants.baseURL,
          connectTimeout: 5000,
          receiveTimeout: 3000
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