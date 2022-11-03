part of 'order_bloc.dart';

enum OrderStatus { initial, loading, fetchSuccess, addSuccess, error }

class OrderState extends Equatable{
  const OrderState({
    this.ordersActive = const <OrderModel>[],
    this.ordersCompleted = const <OrderModel>[],
    this.status = OrderStatus.initial,
    this.message
  });

  final List<OrderModel> ordersActive;
  final List<OrderModel> ordersCompleted;
  final OrderStatus status;
  final String? message;

  @override
  List<Object?> get props => [ordersActive, ordersActive, status];

  OrderState copyWith({
    List<OrderModel>? ordersActive,
    List<OrderModel>? ordersCompleted,
    CardModel? selectedCard,
    OrderStatus? status,
    String? message
  }) {
    return OrderState(
      ordersActive: ordersActive ?? this.ordersActive,
      ordersCompleted: ordersCompleted ?? this.ordersCompleted,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  String toString(){
    return '''OrderState { status : $status }''';
  }
}