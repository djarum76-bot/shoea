part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class OrderAdded extends OrderEvent{
  final String transactionID;
  final List<CartModel> carts;
  final String destinationCityID;
  final CardModel card;
  final String etd;

  OrderAdded(this.transactionID, this.carts, this.destinationCityID, this.card, this.etd);
}

class OrderFetched extends OrderEvent{}