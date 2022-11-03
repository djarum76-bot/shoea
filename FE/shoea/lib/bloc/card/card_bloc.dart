import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shoea/models/card_model.dart';
import 'package:shoea/repositories/card_repository.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final CardRepository cardRepository;

  CardBloc({required this.cardRepository}) : super(const CardState()) {
    on<CardAdded>(
      _onCardAdded
    );
    on<DefaultCardFetched>(
      _onDefaultCardFetched
    );
    on<AllCardFetched>(
      _onAllCardFetched
    );
    on<CardDefaultChanged>(
      _onCardDefaultChanged
    );
  }

  Future<void> _onCardAdded(CardAdded event, Emitter<CardState> emit)async{
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try{
      await cardRepository.addCard(event.bankName, event.number, event.expiredDate, event.cvv, event.cardHolder);
      final cards = await cardRepository.getAllCard();
      final card = await cardRepository.getDefaultCard();
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        cards: cards,
        card: card
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onDefaultCardFetched(DefaultCardFetched event, Emitter<CardState> emit)async{
    try{
      final card = await cardRepository.getDefaultCard();
      emit(state.copyWith(card: card));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onAllCardFetched(AllCardFetched event, Emitter<CardState> emit)async{
    try{
      final cards = await cardRepository.getAllCard();
      emit(state.copyWith(cards: cards));
    }catch(e){
      emit(state.copyWith(
          message: e.toString(),
          status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onCardDefaultChanged(CardDefaultChanged event, Emitter<CardState> emit)async{
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try{
      await cardRepository.changeDefaultCard(event.id);
      final cards = await cardRepository.getAllCard();
      final card = await cardRepository.getDefaultCard();
      emit(state.copyWith(
        card: card,
        cards: cards,
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
}
