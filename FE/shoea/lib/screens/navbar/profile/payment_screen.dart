import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/card/card_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/models/card_model.dart';
import 'package:shoea/utils/modal_dialog.dart';
import 'package:shoea/utils/routes.dart';

class PaymentScreen extends StatelessWidget{
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CardBloc>(context)..add(AllCardFetched()),
      child: Scaffold(
          body: _paymentView(context)
      ),
    );
  }

  Widget _paymentView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<CardBloc, CardState>(
      listener: (context, state){
        if(state.status.isSubmissionFailure){
          EasyLoading.dismiss();
          ModalDialog.dangerDialog(context);
        }
        if(state.status.isSubmissionSuccess){
          EasyLoading.dismiss();
        }
        if(state.status.isSubmissionInProgress){
          EasyLoading.show(status: "Updating...",);
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              headText(context, "Payment"),
              _isHavePayment(context),
              _addNewCardButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _isHavePayment(BuildContext context){
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state){
        if(state.cards.isEmpty){
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No E-Wallet Found",
                  style: GoogleFonts.urbanist(fontSize: 18.sp),
                ),
                Text(
                  "Add Your E-Wallet Below",
                  style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.sp),
                )
              ],
            ),
          );
        }else{
          return _paymentList(context, state);
        }
      },
    );
  }

  Widget _paymentList(BuildContext context, CardState state){
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 2.h, bottom: 0.5.h),
        child: ListView.builder(
          itemCount: state.cards.length,
          itemBuilder: (context, index){
            CardModel card = state.cards[index];
            return _paymentItem(size, card, context);
          },
        ),
      ),
    );
  }

  Widget _paymentItem(Size size, CardModel card, BuildContext context){
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: (){
        if(!card.isDefault!){
          BlocProvider.of<CardBloc>(context).add(CardDefaultChanged(card.id!));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        child: Container(
          width: size.width,
          height: 7.5.h,
          padding: EdgeInsets.all(1.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.1.h,
                width: 10.5.w,
                child: CircleAvatar(
                  radius: 1.h,
                  child: const Center(
                    child: Icon(LineIcons.wallet),
                  ),
                ),
              ),
              SizedBox(width: 2.w,),
              Expanded(
                child: Text(
                  card.bankName!,
                  style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.sp),
                ),
              ),
              SizedBox(
                  height: 4.h,
                  width: 10.h,
                  child: Text(
                    card.isDefault! ? "Connected (Default)" : "Connected",
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 16.sp),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _addNewCardButton(BuildContext context){
    return AppButton(
      onPressed: (){
        Navigator.pushNamed(context, Routes.addNewCardScreen);
      },
      text: "Add New Card",
    );
  }
}