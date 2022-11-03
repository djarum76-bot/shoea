import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shoea/models/cart_model.dart';
import 'package:shoea/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(const CartState()) {
    on<CartFetched>(
      _onCartFetched
    );
    on<CartAdded>(
      _onCartAdded
    );
    on<CartDeleted>(
      _onCartDeleted
    );
    on<CartIncreasedQty>(
      _onCartIncreasedQty
    );
    on<CartDecreasedQty>(
      _onCartDecreasedQty
    );
  }

  Future<void> _onCartFetched(CartFetched event, Emitter<CartState> emit)async{
    try{
      final carts = await cartRepository.getAllCarts();
      emit(state.copyWith(
        carts: carts
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onCartAdded(CartAdded event, Emitter<CartState> emit)async{
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try{
      await cartRepository.addToCart(event.shoeID, event.color, event.size, event.qty);
      final carts = await cartRepository.getAllCarts();
      emit(state.copyWith(
        carts: carts,
        status: FormzStatus.submissionSuccess
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onCartDeleted(CartDeleted event, Emitter<CartState> emit)async{
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try{
      await cartRepository.deleteCart(event.cartID);
      final carts = await cartRepository.getAllCarts();
      emit(state.copyWith(
          carts: carts,
          status: FormzStatus.submissionSuccess
      ));
    }catch(e){
      emit(state.copyWith(
          message: e.toString(),
          status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onCartIncreasedQty(CartIncreasedQty event, Emitter<CartState> emit)async{
    try{
      await cartRepository.updateQtyCart(event.cartID, event.qty + 1);
      final carts = await cartRepository.getAllCarts();
      emit(state.copyWith(
        carts: carts
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onCartDecreasedQty(CartDecreasedQty event, Emitter<CartState> emit)async{
    try{
      if(event.qty != 1){
        await cartRepository.updateQtyCart(event.cartID, event.qty - 1);
        final carts = await cartRepository.getAllCarts();
        emit(state.copyWith(
            carts: carts
        ));
      }
    }catch(e){
      emit(state.copyWith(
          message: e.toString(),
          status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }
}
