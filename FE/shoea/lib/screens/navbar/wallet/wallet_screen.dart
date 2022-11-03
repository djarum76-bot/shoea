import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/card/card_bloc.dart';
import 'package:shoea/bloc/transaction/transaction_bloc.dart';
import 'package:shoea/components/transaction_item.dart';
import 'package:shoea/components/widget/head_icon_text.dart';
import 'package:shoea/models/transaction_model.dart';
import 'package:shoea/utils/routes.dart';
import 'package:formz/formz.dart';

class WalletScreen extends StatelessWidget{
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<CardBloc>(context)..add(DefaultCardFetched()),
        ),
        BlocProvider.value(
          value: BlocProvider.of<TransactionBloc>(context)..add(TransactionFetched()),
        )
      ],
      child: Scaffold(
        body: _walletView(context),
      ),
    );
  }

  Widget _walletView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
        child: Column(
          children: [
            headIconText(context, "My E-Wallet"),
            _isHaveWallet(context),
            _transactionHistory(context),
            _transactionList()
          ],
        ),
      ),
    );
  }

  Widget _isHaveWallet(BuildContext context){
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state){
        if(state.card != null){
          return _creditCard(state);
        }else{
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 28.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please insert your e-wallet here",
                  style: GoogleFonts.urbanist(fontSize: 18.sp),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, Routes.addNewCardScreen);
                  },
                  child: Text(
                    "Add E-Wallet",
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 17.5.sp),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Widget _creditCard(CardState state){
    return CreditCardWidget(
      cardNumber: state.card!.number!,
      expiryDate: state.card!.expiredDate!,
      cardHolderName: state.card!.cardHolder!,
      cvvCode: state.card!.cvv!,
      showBackView: false,
      isHolderNameVisible: true,
      onCreditCardWidgetChange: (creditCardBrand){},
      cardType: CardType.mastercard,
    );
  }

  Widget _transactionHistory(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Transaction History",
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.5.sp),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, Routes.transactionHistoryScreen);
            },
            borderRadius: BorderRadius.circular(200),
            child: Text(
              "See All",
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 17.sp),
            ),
          )
        ],
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
              return ListView.builder(
                itemCount: state.transactions.length,
                itemBuilder: (context, index){
                  TransactionModel transaction = state.transactions[index];
                  return TransactionItem(index: index, transaction: transaction,);
                },
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