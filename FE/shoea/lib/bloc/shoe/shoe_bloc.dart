import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoea/models/brand_model.dart';
import 'package:shoea/models/favorite_model.dart';
import 'package:shoea/models/help_model.dart';
import 'package:shoea/models/history_model.dart';
import 'package:shoea/models/shoe_model.dart';
import 'package:shoea/repositories/favorite_repository.dart';
import 'package:shoea/repositories/history_repository.dart';
import 'package:shoea/repositories/review_repository.dart';
import 'package:shoea/repositories/shoe_repository.dart';
import 'package:shoea/utils/constants.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:uuid/uuid.dart';

part 'shoe_event.dart';
part 'shoe_state.dart';

class ShoeBloc extends Bloc<ShoeEvent, ShoeState> {
  final ShoeRepository shoeRepository;
  final ReviewRepository reviewRepository;
  final HistoryRepository historyRepository;
  final FavoriteRepository favoriteRepository;

  ShoeBloc({required this.shoeRepository, required this.reviewRepository, required this.historyRepository, required this.favoriteRepository}) : super(const ShoeState()) {
    on<ShoeFetched>(
      _onShoeFetched
    );
    on<ShoeNavigation>(
      _onShoeNavigation
    );
    on<ShoeSearchNavigation>(
      _onShoeSearchNavigation
    );
    on<ShoeHistoryFetched>(
      _onShoeHistoryFetched
    );
    on<ShoeHistoryDeleted>(
      _onShoeHistoryDeleted
    );
    on<ShoeHistoryDeletedAll>(
      _onShoeHistoryDeletedAll
    );
    on<ShoeSearchFetched>(
      _onShoeSearchFetched
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
    on<ShoeFavoriteAdded>(
      _onShoeFavoriteAdded
    );
    on<ShoeFavoriteDeleted>(
      _onShoeFavoriteDeleted
    );
  }

  Future<void> _onShoeFetched(ShoeFetched event, Emitter<ShoeState> emit)async{
    emit(state.copyWith(status: ShoeStatus.loading));
    try{
      emit(state.copyWith(selectedBrand: event.brand));
      if(event.isFavorite){
        if(event.brand.name == "All"){
          final shoes = await favoriteRepository.getAllFavoriteShoes();
          emit(state.copyWith(
              shoes: shoes,
              status: ShoeStatus.fetchAllShoeFavoriteSuccess
          ));
        }else{
          final shoes = await favoriteRepository.getAllFavoriteShoesByBrand(event.brand.name!);
          emit(state.copyWith(
              shoes: shoes,
              status: ShoeStatus.fetchBrandFavoriteSuccess
          ));
        }
      }else{
        if(event.brand.name == "All"){
          final shoes = await shoeRepository.getAllPopularShoes();
          emit(state.copyWith(
              shoes: shoes,
              status: ShoeStatus.fetchAllShoeSuccess
          ));
        }else{
          final shoes = await shoeRepository.getAllBrandShoes(event.brand.name!);
          emit(state.copyWith(
              shoes: shoes,
              status: ShoeStatus.fetchBrandSuccess
          ));
        }
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
      final shoes = await shoeRepository.getAllPopularShoes();
      emit(state.copyWith(
          shoes: shoes,
          selectedBrand: Constants.brand,
          status: ShoeStatus.fetchAllShoeSuccess
      ));
    }catch(e){
      emit(state.copyWith(
          status: ShoeStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onShoeSearchNavigation(ShoeSearchNavigation event, Emitter<ShoeState> emit)async{
    try{
      final histories = await historyRepository.getHistories();
      emit(state.copyWith(
          status: ShoeStatus.searchNavigation,
          histories: histories
      ));
    }catch(e){
      emit(state.copyWith(
          status: ShoeStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onShoeHistoryFetched(ShoeHistoryFetched event, Emitter<ShoeState> emit)async{
    emit(state.copyWith(status: ShoeStatus.loading));
    try{
      final histories = await historyRepository.getHistories();
      emit(state.copyWith(
        status: ShoeStatus.fetchHistorySuccess,
        histories: histories
      ));
    }catch(e){
      emit(state.copyWith(
        status: ShoeStatus.error,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onShoeHistoryDeleted(ShoeHistoryDeleted event, Emitter<ShoeState> emit)async{
    emit(state.copyWith(status: ShoeStatus.loading));
    try{
      await historyRepository.deleteHistory(event.uuid);
      final histories = await historyRepository.getHistories();
      emit(state.copyWith(
          status: ShoeStatus.fetchHistorySuccess,
          histories: histories
      ));
    }catch(e){
      emit(state.copyWith(
          status: ShoeStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onShoeHistoryDeletedAll(ShoeHistoryDeletedAll event, Emitter<ShoeState> emit)async{
    emit(state.copyWith(status: ShoeStatus.loading));
    try{
      await historyRepository.deleteAllHistory();
      final histories = await historyRepository.getHistories();
      emit(state.copyWith(
          status: ShoeStatus.fetchHistorySuccess,
          histories: histories
      ));
    }catch(e){
      emit(state.copyWith(
          status: ShoeStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onShoeSearchFetched(ShoeSearchFetched event, Emitter<ShoeState> emit)async{
    emit(state.copyWith(status: ShoeStatus.loading));
    try{
      if(state.histories.map((history) => history.name).contains(event.query)){
        final index = state.histories.indexWhere((history) => history.name == event.query);
        final HistoryModel history = HistoryModel(
          uuid: state.histories[index].uuid,
          name: event.query,
          accessAt: DateTime.now().toIso8601String(),
        );
        await historyRepository.updateHistory(history);
      }else{
        var uuid = const Uuid();
        final HistoryModel history = HistoryModel(
          uuid: uuid.v1(),
          name: event.query,
          accessAt: DateTime.now().toIso8601String(),
        );
        await historyRepository.insertHistory(history);
      }
      final shoes = await shoeRepository.getAllShoesSearch(event.query);
      emit(state.copyWith(
          status: ShoeStatus.fetchSearchSuccess,
          shoes: shoes,
          search: event.query
      ));
    }catch(e){
      emit(state.copyWith(
          status: ShoeStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onShoeDetailFetched(ShoeDetailFetched event, Emitter<ShoeState> emit)async{
    emit(state.copyWith(status: ShoeStatus.loading));
    try{
      final shoe = await shoeRepository.getShoe(event.id);
      final favorite = await favoriteRepository.getFavorite(event.id);
      emit(state.copyWith(
        shoe: shoe,
        favorite: favorite,
        size: () => null,
        color: () => null,
        qty: 1,
        status: ShoeStatus.fetchDetailShoeSuccess
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
    emit(state.copyWith(status: ShoeStatus.loadingOrder));
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

  Future<void> _onShoeFavoriteAdded(ShoeFavoriteAdded event, Emitter<ShoeState> emit)async{
    try{
      if(event.helper.isFavorite){
        await favoriteRepository.addToFavorite(event.helper.shoeID);
        final favorite = await favoriteRepository.getFavorite(event.helper.shoeID);
        if(event.helper.brand.name == "All"){
          final shoes = await favoriteRepository.getAllFavoriteShoes();
          emit(state.copyWith(
              favorite: favorite,
              shoes: shoes,
              selectedBrand: event.helper.brand,
              status: ShoeStatus.fetchDetailShoeSuccess
          ));
        }else{
          final shoes = await favoriteRepository.getAllFavoriteShoesByBrand(event.helper.brand.name!);
          emit(state.copyWith(
              favorite: favorite,
              shoes: shoes,
              selectedBrand: event.helper.brand,
              status: ShoeStatus.fetchDetailShoeSuccess
          ));
        }
      }else{
        await favoriteRepository.addToFavorite(event.helper.shoeID);
        final favorite = await favoriteRepository.getFavorite(event.helper.shoeID);
        emit(state.copyWith(
            favorite: favorite,
            status: ShoeStatus.fetchDetailShoeSuccess
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

  Future<void> _onShoeFavoriteDeleted(ShoeFavoriteDeleted event, Emitter<ShoeState> emit)async{
    try{
      if(event.helper.isFavorite){
        await favoriteRepository.deleteFromFavorite(event.favoriteID);
        final favorite = await favoriteRepository.getFavorite(event.helper.shoeID);
        if(event.helper.brand.name == "All"){
          final shoes = await favoriteRepository.getAllFavoriteShoes();
          emit(state.copyWith(
              favorite: favorite,
              shoes: shoes,
              selectedBrand: event.helper.brand,
              status: ShoeStatus.fetchDetailShoeSuccess
          ));
        }else{
          final shoes = await favoriteRepository.getAllFavoriteShoesByBrand(event.helper.brand.name!);
          emit(state.copyWith(
              favorite: favorite,
              shoes: shoes,
              selectedBrand: event.helper.brand,
              status: ShoeStatus.fetchDetailShoeSuccess
          ));
        }
      }else{
        await favoriteRepository.deleteFromFavorite(event.favoriteID);
        final favorite = await favoriteRepository.getFavorite(event.helper.shoeID);
        emit(state.copyWith(
            favorite: favorite,
            status: ShoeStatus.fetchDetailShoeSuccess
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
}
