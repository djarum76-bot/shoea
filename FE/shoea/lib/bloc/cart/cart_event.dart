part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CartFetched extends CartEvent{}

class CartAdded extends CartEvent{
  final int shoeID;
  final String color;
  final int size;
  final int qty;

  CartAdded(this.shoeID, this.color, this.size, this.qty);
}

class CartDeleted extends CartEvent{
  final int cartID;

  CartDeleted(this.cartID);
}

class CartIncreasedQty extends CartEvent{
  final int cartID;
  final int qty;

  CartIncreasedQty(this.cartID, this.qty);
}

class CartDecreasedQty extends CartEvent{
  final int cartID;
  final int qty;

  CartDecreasedQty(this.cartID, this.qty);
}