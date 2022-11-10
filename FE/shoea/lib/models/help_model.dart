import 'package:shoea/models/brand_model.dart';

class HelpModel{
  final int shoeID;
  final BrandModel brand;
  final bool isFavorite;

  HelpModel({required this.shoeID, required this.brand, required this.isFavorite});
}