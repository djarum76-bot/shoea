part of 'cart_bloc.dart';

class CartState extends Equatable{
  const CartState({
    this.carts = const <CartModel>[],
    this.status = FormzStatus.pure,
    this.message
  });

  final List<CartModel> carts;
  final FormzStatus status;
  final String? message;

  @override
  List<Object?> get props => [carts, status];

  CartState copyWith({
    List<CartModel>? carts,
    FormzStatus? status,
    String? message
  }) {
    return CartState(
      carts: carts ?? this.carts,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  String toString(){
    return '''CartState { status : $status }''';
  }
}