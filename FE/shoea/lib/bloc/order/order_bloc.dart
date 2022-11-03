import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoea/models/card_model.dart';
import 'package:shoea/models/cart_model.dart';
import 'package:shoea/models/order_model.dart';
import 'package:shoea/repositories/order_repository.dart';
import 'package:shoea/repositories/transaction_repository.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/list_item.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;
  final TransactionRepository transactionRepository;

  OrderBloc({required this.orderRepository, required this.transactionRepository}) : super(const OrderState()) {
    on<OrderAdded>(
      _onOrderAdded
    );
    on<OrderFetched>(
      _onOrderFetched
    );
  }

  Future<void> _onOrderAdded(OrderAdded event, Emitter<OrderState> emit)async{
    emit(state.copyWith(status: OrderStatus.loading));
    try{
      DateTime now = DateTime.now();
      for(var cart in event.carts){
        await orderRepository.addToOrder(cart.shoeId!, event.destinationCityID, cart.price!, event.etd, now);
        await transactionRepository.addToTransaction(event.transactionID, cart.shoeId!, cart.color!, cart.size!, cart.qty!, cart.price!, event.card.bankName!, now);
      }
      emit(state.copyWith(status: OrderStatus.addSuccess));
    }catch(e){
      emit(state.copyWith(
        status: OrderStatus.error,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onOrderFetched(OrderFetched event, Emitter<OrderState> emit)async{
    emit(state.copyWith(status: OrderStatus.loading));
    try{
      final orders = await orderRepository.getAllOrder();
      emit(state.copyWith(
        ordersActive: ListItem.sortOrder(orders, Constants.active),
        ordersCompleted: ListItem.sortOrder(orders, Constants.completed),
        status: OrderStatus.fetchSuccess
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: OrderStatus.error
      ));
      throw Exception(e);
    }
  }
}
