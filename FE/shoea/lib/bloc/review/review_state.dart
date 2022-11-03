part of 'review_bloc.dart';

class ReviewState extends Equatable{
  const ReviewState({
    this.reviews = const <ReviewModel>[],
    this.rating = "All",
    this.status = FormzStatus.pure,
    this.message
  });

  final List<ReviewModel> reviews;
  final String rating;
  final FormzStatus status;
  final String? message;

  @override
  List<Object?> get props => [reviews, rating, status];

  ReviewState copyWith({
    List<ReviewModel>? reviews,
    String? rating,
    FormzStatus? status,
    String? message
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  String toString(){
    return '''OrderState { status : $status }''';
  }
}
