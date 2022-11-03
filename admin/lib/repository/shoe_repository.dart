import 'package:admin/service/internet_service.dart';
import 'package:admin/utils/constants.dart';
import 'package:dio/dio.dart';

class ShoeRepository{
  Future<void> addShoe(String brand, String image, String title, String description, int price, List<int> sizes, List<String> colors)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.brand : brand,
        Constants.image : await MultipartFile.fromFile(image, filename: image.split('/').last),
        Constants.title : title,
        Constants.description : description,
        Constants.price : price,
      });

      for (var size in sizes){
        formData.fields.addAll([
          MapEntry(Constants.size, size.toString())
        ]);
      }

      for (var color in colors){
        formData.fields.addAll([
          MapEntry(Constants.color, color)
        ]);
      }

      await InternetService.dio.post("/add-shoe",
          data: formData,
          options: Options(
              headers: {
                Constants.accept : Constants.appJson,
              }
          )
      );
    }catch(e){
      throw Exception(e);
    }
  }
}