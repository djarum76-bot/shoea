part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class ReviewFetched extends ReviewEvent{
  final int shoeID;
  final String rating;

  ReviewFetched(this.shoeID, this.rating);
}