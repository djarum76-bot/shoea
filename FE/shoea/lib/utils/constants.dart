import 'package:shoea/models/brand_model.dart';
import 'package:simple_icons/simple_icons.dart';

class Constants{
  static const male = "Male";
  static const female = "Female";

  static const baseURL = "http://192.168.100.51:8080";
  // static const baseURL = "http://192.168.64.249:8080";
  // static const baseURL = "http://192.168.135.249:8080";
  // static const baseURL = "http://192.168.142.249:8080";
  // static const baseURL = "http://192.168.82.249:8080";

  static const email = "email";
  static const password = "password";

  static const accept = "Accept";
  static const appJson = "application/json";
  static const appForm = "application/x-www-form-urlencoded";
  static const authorization = "Authorization";
  static const bearer = "bearer";
  static const token = "token";

  static const isSkipIntro = "isSkipIntro";

  static const picture = "picture";
  static const name = "name";
  static const date = "date";
  static const phone = "phone";
  static const gender = "gender";
  static const pin = "pin";

  static const bankName = "bank_name";
  static const number = "number";
  static const expired = "expired_date";
  static const cvv = "cvv";
  static const holder = "card_holder";

  static const provinceID = "province_id";
  static const cityID = "city_id";
  static const lat = "lat";
  static const lng = "lng";
  static const addressName = "address_name";
  static const provinceName = "province_name";
  static const cityName = "city_name";
  static const addressDetail = "address_detail";

  static const color = "color";
  static const size = "size";
  static const qty = "qty";

  static const key = "key";
  static const ongkirApiKey = "547ed56e4309f4be9765719055631071";

  static const rajaOngkir = "rajaongkir";
  static const results = "results";
  static const costs = "costs";

  static const origin = "origin";
  static const destination = "destination";
  static const weight = "weight";
  static const courier = "courier";
  static const jne = "jne";

  static const transactionID = "transaction_id";
  static const shoeID = "shoe_id";
  static const originCityID = "origin_city_id";
  static const destinationCityID = "destination_city_id";
  static const price = "price";
  static const payment = "payment";
  static const etd = "etd";
  static const createdAt = "created_at";

  static const active = "Active";
  static const completed = "Completed";

  static const orderID = "order_id";
  static const rating = "rating";
  static const comment = "comment";

  static const dbName = "histories";
  static const id = "id";
  static const uuid = "uuid";
  static const accessAt = "access_at";

  static const brand = BrandModel(icon: SimpleIcons.adidas, name: "All", id: 0);
}