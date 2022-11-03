import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/transaction/transaction_bloc.dart';
import 'package:shoea/components/transaction_item.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:formz/formz.dart';
import 'package:shoea/models/transaction_model.dart';

class TransactionHistoryScreen extends StatelessWidget{
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<TransactionBloc>(context)..add(TransactionFetched()),
      child: Scaffold(
        body: _transactionHistory(context),
      ),
    );
  }

  Widget _transactionHistory(BuildContext context){
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
        child: Column(
          children: [
            headText(context, "Transaction History"),
            _transactionList()
          ],
        ),
      ),
    );
  }

  Widget _transactionList(){
    return Expanded(
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state){
          if(state.status.isSubmissionInProgress){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if(state.status.isSubmissionSuccess){
            if(state.transactions.isEmpty){
              return Center(
                child: Text(
                  "No Transaction Found",
                  style: GoogleFonts.urbanist(fontSize: 18.sp),
                ),
              );
            }else{
              return Padding(
                padding: EdgeInsets.only(top: 1.5.h),
                child: ListView.builder(
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index){
                    TransactionModel transaction = state.transactions[index];
                    return TransactionItem(index: index, transaction: transaction,);
                  },
                ),
              );
            }
          }else{
            return Center(
              child: Text(
                state.message ?? "Error",
                style: GoogleFonts.urbanist(fontSize: 18.sp),
              ),
            );
          }
        },
      ),
    );
  }
}