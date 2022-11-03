part of 'transaction_bloc.dart';

class TransactionState extends Equatable{
  const TransactionState({
    this.transactions = const <TransactionModel>[],
    this.status = FormzStatus.pure,
    this.message
  });

  final List<TransactionModel> transactions;
  final FormzStatus status;
  final String? message;

  @override
  List<Object?> get props => [transactions, status];

  TransactionState copyWith({
    List<TransactionModel>? transactions,
    FormzStatus? status,
    String? message
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  String toString(){
    return '''TransactionState { status : $status }''';
  }
}
