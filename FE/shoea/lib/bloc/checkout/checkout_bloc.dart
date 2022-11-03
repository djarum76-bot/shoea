import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoea/models/address_model.dart';
import 'package:shoea/models/card_model.dart';
import 'package:shoea/models/cart_model.dart';
import 'package:shoea/models/ongkir/shipping_model.dart';
import 'package:shoea/repositories/address_repository.dart';
import 'package:shoea/repositories/checkout_repository.dart';
import 'package:shoea/utils/total_carts_price.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final AddressRepository addressRepository;
  final CheckoutRepository orderRepository;

  CheckoutBloc({required this.addressRepository, required this.orderRepository}) : super(const CheckoutState()) {
    on<CheckoutInitial>(
      _onCheckoutInitial
    );
    on<CheckoutShippingAddressFetched>(
        _onCheckoutShippingAddressFetched
    );
    on<CheckoutShippingAddressChanged>(
        _onCheckoutShippingAddressChanged
    );
    on<CheckoutOrder>(
        _onCheckoutOrder
    );
    on<CheckoutShippingTypeFetched>(
      _onCheckoutShippingTypeFetched
    );
    on<CheckoutShippingTypeChanged>(
      _onCheckoutShippingTypeChanged
    );
    on<CheckoutPaymentSelected>(
      _onCheckoutPaymentSelected
    );
  }

  void _onCheckoutInitial(CheckoutInitial event, Emitter<CheckoutState> emit)async{
    emit(state.copyWith(status: CheckoutStatus.initial));
  }

  Future<void> _onCheckoutShippingAddressFetched(CheckoutShippingAddressFetched event, Emitter<CheckoutState> emit)async{
    emit(state.copyWith(status: CheckoutStatus.loading));
    try{
      final address = await addressRepository.getDefaultAddress();
      emit(state.copyWith(
          address: address,
          status: CheckoutStatus.fetchAddressSuccess
      ));
    }catch(e){
      emit(state.copyWith(
          message: e.toString(),
          status: CheckoutStatus.error
      ));
      throw Exception(e);
    }
  }

  void _onCheckoutShippingAddressChanged(CheckoutShippingAddressChanged event, Emitter<CheckoutState> emit)async{
    emit(state.copyWith(
        address: event.address,
        shipping: 0,
        total: state.amount,
        selectedShipping: () => null,
        shippings: <ShippingModel>[]
    ));
  }

  void _onCheckoutOrder(CheckoutOrder event, Emitter<CheckoutState> emit)async{
    emit(state.copyWith(
        carts: event.carts,
        amount: totalCartsPrice(event.carts),
        total: totalCartsPrice(event.carts),
        shipping: 0,
        selectedShipping: () => null,
        status: CheckoutStatus.fetchCartSuccess
    ));
  }

  Future<void> _onCheckoutShippingTypeFetched(CheckoutShippingTypeFetched event, Emitter<CheckoutState> emit)async{
    emit(state.copyWith(status: CheckoutStatus.loading));
    try{
      final shippings = await orderRepository.getShippingType(event.destinationCityID);
      emit(state.copyWith(
        shippings: shippings,
        status: CheckoutStatus.fetchShippingSuccess
      ));
    }catch(e){
      emit(state.copyWith(
          message: e.toString(),
          status: CheckoutStatus.error
      ));
      throw Exception(e);
    }
  }

  void _onCheckoutShippingTypeChanged(CheckoutShippingTypeChanged event, Emitter<CheckoutState> emit)async{
    emit(state.copyWith(
      selectedShipping: () => event.selectedShipping,
      shipping: event.selectedShipping.cost![0].value!,
      total: state.amount + event.selectedShipping.cost![0].value!,
      status: CheckoutStatus.updateShippingSuccess
    ));
  }

  void _onCheckoutPaymentSelected(CheckoutPaymentSelected event, Emitter<CheckoutState> emit){
    emit(state.copyWith(
        card: event.card,
        status: CheckoutStatus.selectedCardSuccess
    ));
  }
}
