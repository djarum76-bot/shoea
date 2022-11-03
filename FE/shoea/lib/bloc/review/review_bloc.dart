import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shoea/models/review_model.dart';
import 'package:shoea/repositories/review_repository.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewBloc({required this.reviewRepository}) : super(const ReviewState()) {
    on<ReviewFetched>(
      _onReviewFetched
    );
  }

  Future<void> _onReviewFetched(ReviewFetched event, Emitter<ReviewState> emit)async{
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try{
      if(event.rating == "All"){
        final reviews = await reviewRepository.getAllReviewByShoeID(event.shoeID);
        emit(state.copyWith(
            reviews: reviews,
            rating: event.rating,
            status: FormzStatus.submissionSuccess
        ));
      }else{
        final reviews = await reviewRepository.getAllReviewByShoeIDAndRating(event.shoeID, event.rating);
        emit(state.copyWith(
            reviews: reviews,
            rating: event.rating,
            status: FormzStatus.submissionSuccess
        ));
      }
    }catch(e){
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }
}
