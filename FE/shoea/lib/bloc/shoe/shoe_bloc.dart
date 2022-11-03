import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoea/models/brand_model.dart';
import 'package:shoea/models/shoe_model.dart';
import 'package:shoea/repositories/review_repository.dart';
import 'package:shoea/repositories/shoe_repository.dart';
import 'package:simple_icons/simple_icons.dart';

part 'shoe_event.dart';
part 'shoe_state.dart';

class ShoeBloc extends Bloc<ShoeEvent, ShoeState> {
  final ShoeRepository shoeRepository;
  final ReviewRepository reviewRepository;

  ShoeBloc({required this.shoeRepository, required this.reviewRepository}) : super(const ShoeState()) {
    on<ShoeFetched>(
      _onShoeFetched
    );
    on<ShoeNavigation>(
      _onShoeNavigation
    );
    on<ShoeDetailNavigation>(
      _onShoeDetailNavigation
    );
    on<ShoeSearch>(
      _onShoeSearch
    );
    on<ShoeDetailFetched>(
      _onShoeDetailFetched
    );
    on<ShoeSizeChanged>(
      _onShoeSizeChanged
    );
    on<ShoeColorChanged>(
      _onShoeColorChanged
    );
    on<ShoeQtyIncreased>(
      _onShoeQtyIncreased
    );
    on<ShoeQtyDecreased>(
      _onShoeQtyDecreased
    );
    on<ShoeReviewAdded>(
      _onShoeReviewAdded
    );
  }

  Future<void> _onShoeFetched(ShoeFetched event, Emitter<ShoeState> emit)async{
    try{
      emit(state.copyWith(selectedBrand: event.brand));
      if(event.brand.name == "All"){
        final shoes = await shoeRepository.getAllPopularShoes();
        emit(state.copyWith(
            shoes: shoes
        ));
      }else{
        final shoes = await shoeRepository.getAllBrandShoes(event.brand.name!);
        emit(state.copyWith(
          shoes: shoes
        ));
      }
    }catch(e){
      emit(state.copyWith(
        status: ShoeStatus.error,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onShoeNavigation(ShoeNavigation event, Emitter<ShoeState> emit)async{
    try{
      emit(state.copyWith(selectedBrand: event.brand));
      if(event.brand.name == "All"){
        final shoes = await shoeRepository.getAllPopularShoes();
        emit(state.copyWith(
            shoes: shoes,
            status: ShoeStatus.initial
        ));
      }else{
        final shoes = await shoeRepository.getAllBrandShoes(event.brand.name!);
        emit(state.copyWith(
            shoes: shoes
        ));
      }
    }catch(e){
      emit(state.copyWith(
          status: ShoeStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  void _onShoeDetailNavigation(ShoeDetailNavigation event, Emitter<ShoeState> emit){
    emit(state.copyWith(
      size: () => null,
      color: () => null,
      qty: 1
    ));
  }

  void _onShoeSearch(ShoeSearch event, Emitter<ShoeState> emit){
    String adidas = "adidas";
    if(event.query == ""){
      emit(state.copyWith(status: ShoeStatus.initial));
    }else{
      if(adidas.contains(event.query.toLowerCase())){
        emit(state.copyWith(
          status: ShoeStatus.data,
          search: event.query
        ));
      }else{
        emit(state.copyWith(
          status: ShoeStatus.noData,
          search: event.query
        ));
      }
    }
  }

  Future<void> _onShoeDetailFetched(ShoeDetailFetched event, Emitter<ShoeState> emit)async{
    try{
      final shoe = await shoeRepository.getShoe(event.id);
      emit(state.copyWith(
        shoe: shoe
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: ShoeStatus.error
      ));
      throw Exception(e);
    }
  }

  void _onShoeSizeChanged(ShoeSizeChanged event, Emitter<ShoeState> emit){
    emit(state.copyWith(
      size: () => event.size
    ));
  }

  void _onShoeColorChanged(ShoeColorChanged event, Emitter<ShoeState> emit){
    emit(state.copyWith(
      color: () => event.color
    ));
  }

  void _onShoeQtyIncreased(ShoeQtyIncreased event, Emitter<ShoeState> emit){
    emit(state.copyWith(
      qty: state.qty + 1
    ));
  }

  void _onShoeQtyDecreased(ShoeQtyDecreased event, Emitter<ShoeState> emit){
    if(state.qty != 1){
      emit(state.copyWith(
        qty: state.qty - 1
      ));
    }
  }

  Future<void> _onShoeReviewAdded(ShoeReviewAdded event, Emitter<ShoeState> emit)async{
    emit(state.copyWith(status: ShoeStatus.loading));
    try{
      await reviewRepository.addReview(event.orderID, event.shoeID, event.rating, event.comment);
      final shoes = await shoeRepository.getAllPopularShoes();
      emit(state.copyWith(
        status: ShoeStatus.addReviewSuccess,
        shoes: shoes
      ));
    }catch(e){
      emit(state.copyWith(
        status: ShoeStatus.error,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }
}
