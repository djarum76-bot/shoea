import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shoea/models/transaction_model.dart';
import 'package:shoea/repositories/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc({required this.transactionRepository}) : super(const TransactionState()) {
    on<TransactionFetched>(
      _onTransactionFetched
    );
  }

  Future<void> _onTransactionFetched(TransactionFetched event, Emitter<TransactionState> emit)async{
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try{
      final transactions = await transactionRepository.getAllTransaction();
      emit(state.copyWith(
        transactions: transactions,
        status: FormzStatus.submissionSuccess
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
