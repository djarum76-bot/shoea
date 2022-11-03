part of 'checkout_bloc.dart';

class CheckoutEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CheckoutInitial extends CheckoutEvent{}

class CheckoutShippingAddressFetched extends CheckoutEvent{}

class CheckoutShippingAddressChanged extends CheckoutEvent{
  final AddressModel address;

  CheckoutShippingAddressChanged(this.address);
}

class CheckoutOrder extends CheckoutEvent{
  final List<CartModel> carts;

  CheckoutOrder(this.carts);
}

class CheckoutShippingTypeFetched extends CheckoutEvent{
  final String destinationCityID;

  CheckoutShippingTypeFetched(this.destinationCityID);
}

class CheckoutShippingTypeChanged extends CheckoutEvent{
  final ShippingModel selectedShipping;

  CheckoutShippingTypeChanged(this.selectedShipping);
}

class CheckoutPaymentSelected extends CheckoutEvent{
  final CardModel card;

  CheckoutPaymentSelected(this.card);
}