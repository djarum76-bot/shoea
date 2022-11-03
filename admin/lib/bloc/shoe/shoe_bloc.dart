import 'dart:async';

import 'package:admin/repository/shoe_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

part 'shoe_event.dart';
part 'shoe_state.dart';

class ShoeBloc extends Bloc<ShoeEvent, ShoeState> {
  final ShoeRepository shoeRepository;
  ShoeBloc({required this.shoeRepository}) : super(const ShoeState()) {
    on<ShoeImage>(
      _onShoeImage
    );
    on<ShoeSizeAdded>(
      _onShoeSizeAdded
    );
    on<ShoeSizeRemoved>(
        _onShoeSizeRemoved
    );
    on<ShoeColorAdded>(
        _onShoeColorAdded
    );
    on<ShoeColorRemoved>(
        _onShoeColorRemoved
    );
    on<ShoeAdded>(
      _onShoeAdded
    );
  }

  Future<void> _onShoeImage(ShoeImage event, Emitter<ShoeState> emit)async{
    try{
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

      if(image != null){
        emit(state.copyWith(
            image: () => image.path
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

  void _onShoeSizeAdded(ShoeSizeAdded event, Emitter<ShoeState> emit){
    emit(state.copyWith(
      sizes: event.sizes
    ));
  }

  void _onShoeSizeRemoved(ShoeSizeRemoved event, Emitter<ShoeState> emit){
    emit(state.copyWith(
      sizes: event.sizes
    ));
  }

  void _onShoeColorAdded(ShoeColorAdded event, Emitter<ShoeState> emit){
    emit(state.copyWith(
        colors: event.colors
    ));
  }

  void _onShoeColorRemoved(ShoeColorRemoved event, Emitter<ShoeState> emit){
    emit(state.copyWith(
        colors: event.colors
    ));
  }

  Future<void> _onShoeAdded(ShoeAdded event, Emitter<ShoeState> emit)async{
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try{
      await shoeRepository.addShoe(event.brand, event.image, event.title, event.description, event.price, event.sizes, event.colors);
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        image: () => null,
        sizes: <int>[],
        colors: <int>[],
      ));
    }catch(e){
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }
}
