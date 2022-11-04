import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoea/models/address_model.dart';
import 'package:shoea/models/ongkir/city_model.dart';
import 'package:shoea/models/ongkir/province_model.dart';
import 'package:shoea/repositories/address_repository.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository addressRepository;

  AddressBloc({required this.addressRepository}) : super(const AddressState()){
    on<ProvinceSelected>(
      _onProvinceSelected
    );
    on<CitySelected>(
      _onCitySelected
    );
    on<AddressAdded>(
      _onAddressAdded
    );
    on<AddressFetched>(
      _onAddressFetched
    );
    on<AddressDefaultChanged>(
      _onAddressDefaultChanged
    );
    on<AddressUpdated>(
      _onAddressUpdated
    );
  }

  void _onProvinceSelected(ProvinceSelected event, Emitter<AddressState> emit){
    emit(state.copyWith(
      selectedProvince: () => event.selectedProvince,
      status: AddressStatus.initial
    ));
  }

  void _onCitySelected(CitySelected event, Emitter<AddressState> emit){
    emit(state.copyWith(
      selectedCity: () => event.selectedCity,
      status: AddressStatus.initial
    ));
  }

  Future<void> _onAddressAdded(AddressAdded event, Emitter<AddressState> emit)async{
    emit(state.copyWith(status: AddressStatus.addLoading));
    try{
      await addressRepository.addAddress(event.provinceID, event.cityID, event.lat, event.lng, event.addressName, event.addressDetail);
      final addresses = await addressRepository.getAllAddress();
      final address = await addressRepository.getDefaultAddress();
      emit(state.copyWith(
        status: AddressStatus.addSuccess,
        selectedProvince: () => null,
        selectedCity: () => null,
        addresses: addresses,
        address: address
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: AddressStatus.error
      ));
      throw Exception(e);
    }
  }

  Future<void> _onAddressFetched(AddressFetched event, Emitter<AddressState> emit)async{
    emit(state.copyWith(status: AddressStatus.fetchLoading));
    try{
      final address = await addressRepository.getDefaultAddress();
      final addresses = await addressRepository.getAllAddress();
      emit(state.copyWith(
        address: address,
        addresses: addresses,
        status: AddressStatus.fetchSuccess
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: AddressStatus.error
      ));
      throw Exception(e);
    }
  }

  Future<void> _onAddressDefaultChanged(AddressDefaultChanged event, Emitter<AddressState> emit)async{
    emit(state.copyWith(status: AddressStatus.updateLoading));
    try{
      await addressRepository.changeDefaultAddress(event.id);
      final address = await addressRepository.getDefaultAddress();
      final addresses = await addressRepository.getAllAddress();
      emit(state.copyWith(
          addresses: addresses,
          address: address,
          status: AddressStatus.updateDefaultSuccess
      ));
    }catch(e){
      emit(state.copyWith(
          message: e.toString(),
          status: AddressStatus.error
      ));
      throw Exception(e);
    }
  }

  Future<void> _onAddressUpdated(AddressUpdated event, Emitter<AddressState> emit)async{
    emit(state.copyWith(status: AddressStatus.updateLoading));
    try{
      await addressRepository.updateAddress(event.id, event.provinceID, event.cityID, event.addressName, event.addressDetail);
      final address = await addressRepository.getDefaultAddress();
      final addresses = await addressRepository.getAllAddress();
      emit(state.copyWith(
          address: address,
          addresses: addresses,
          selectedCity: () => null,
          selectedProvince: () => null,
          status: AddressStatus.updateMapSuccess
      ));
    }catch(e){
      emit(state.copyWith(
          message: e.toString(),
          status: AddressStatus.error
      ));
      throw Exception(e);
    }
  }
}
