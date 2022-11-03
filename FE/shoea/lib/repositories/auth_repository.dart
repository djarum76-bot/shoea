import 'package:dio/dio.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/service/internet_service.dart';

class AuthRepository{
  Future<void> register(String email, String password)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.email : email,
        Constants.password : password
      });

      final response = await InternetService.dio.post("/register",
        data: formData,
        options: Options(
          headers: {
            Constants.accept : Constants.appJson
          }
        )
      );

      if(response.statusCode == 200){
        await StorageService.box.write(Constants.token, response.data[Constants.token]);
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> login(String email, String password)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.email : email,
        Constants.password : password
      });

      final response = await InternetService.dio.post("/login",
        data: formData,
        options: Options(
          headers: {
            Constants.accept : Constants.appJson
          }
        )
      );

      if(response.statusCode == 200){
        await StorageService.box.write(Constants.token, response.data[Constants.token]);
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> logout()async{
    await StorageService.box.remove(Constants.token);
  }
}