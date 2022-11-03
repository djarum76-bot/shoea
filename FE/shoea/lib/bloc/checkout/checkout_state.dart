part of 'checkout_bloc.dart';

enum CheckoutStatus { initial, loading, error, fetchAddressSuccess, fetchCartSuccess, fetchShippingSuccess, updateShippingSuccess, selectedCardSuccess }

class CheckoutState extends Equatable{
  const CheckoutState({
    this.address,
    this.carts = const <CartModel>[],
    this.shippings = const <ShippingModel>[],
    this.selectedShipping,
    this.amount = 0,
    this.shipping = 0,
    this.total = 0,
    this.card,
    this.status = CheckoutStatus.initial,
    this.message
  });

  final AddressModel? address;
  final List<CartModel> carts;
  final List<ShippingModel> shippings;
  final ShippingModel? selectedShipping;
  final int amount;
  final int shipping;
  final int total;
  final CardModel? card;
  final CheckoutStatus status;
  final String? message;

  @override
  List<Object?> get props => [ address, carts, shippings, selectedShipping, amount, shipping, total, card, status];

  CheckoutState copyWith({
    AddressModel? address,
    List<CartModel>? carts,
    List<ShippingModel>? shippings,
    ValueGetter<ShippingModel?>? selectedShipping,
    int? amount,
    int? shipping,
    int? total,
    CardModel? card,
    CheckoutStatus? status,
    String? message,
  }) {
    return CheckoutState(
        address: address ?? this.address,
        carts: carts ?? this.carts,
        shippings: shippings ?? this.shippings,
        selectedShipping: selectedShipping != null ? selectedShipping() : this.selectedShipping,
        amount: amount ?? this.amount,
        shipping: shipping ?? this.shipping,
        total: total ?? this.total,
        card: card ?? this.card,
        status: status ?? this.status,
        message: message ?? this.message
    );
  }

  @override
  String toString(){
    return '''CheckoutState { status : $status }''';
  }
}