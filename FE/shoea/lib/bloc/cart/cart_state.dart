part of 'cart_bloc.dart';

enum CartStatus { initial, addLoading, fetchLoading, deleteLoading, addSuccess, fetchSuccess, deleteSuccess, addError, fetchError, deleteError, error }

class CartState extends Equatable{
  const CartState({
    this.carts = const <CartModel>[],
    this.status = CartStatus.initial,
    this.message
  });

  final List<CartModel> carts;
  final CartStatus status;
  final String? message;

  @override
  List<Object?> get props => [carts, status];

  CartState copyWith({
    List<CartModel>? carts,
    CartStatus? status,
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