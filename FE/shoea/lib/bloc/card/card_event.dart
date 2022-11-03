part of 'card_bloc.dart';

abstract class CardEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CardAdded extends CardEvent{
  final String bankName;
  final String number;
  final String expiredDate;
  final String cvv;
  final String cardHolder;

  CardAdded(this.bankName, this.number, this.expiredDate, this.cvv, this.cardHolder);
}

class DefaultCardFetched extends CardEvent{}

class AllCardFetched extends CardEvent{}

class CardDefaultChanged extends CardEvent{
  final int id;

  CardDefaultChanged(this.id);
}