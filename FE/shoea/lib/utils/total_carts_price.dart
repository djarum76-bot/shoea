import 'package:shoea/models/cart_model.dart';

int totalCartsPrice(List<CartModel> carts){
  int total = 0;

  for(var cart in carts){
    total += (cart.price! * cart.qty!);
  }

  return total;
}