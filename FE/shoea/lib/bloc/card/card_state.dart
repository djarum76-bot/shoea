part of 'card_bloc.dart';

class CardState extends Equatable{
  const CardState({
    this.cards = const <CardModel>[],
    this.card,
    this.status = FormzStatus.pure,
    this.message
  });

  final List<CardModel> cards;
  final CardModel? card;
  final FormzStatus status;
  final String? message;

  @override
  List<Object?> get props => [cards, card, status];

  CardState copyWith({
    List<CardModel>? cards,
    CardModel? card,
    FormzStatus? status,
    String? message
  }) {
    return CardState(
      cards: cards ?? this.cards,
      card: card ?? this.card,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  String toString(){
    return '''CardState { status : $status }''';
  }
}
