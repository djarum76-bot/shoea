import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/card/card_bloc.dart';
import 'package:shoea/bloc/checkout/checkout_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/models/card_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/modal_dialog.dart';
import 'package:shoea/utils/routes.dart';

class PaymentMethodScreen extends StatelessWidget{
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CardBloc>(context)..add(AllCardFetched()),
      child: Scaffold(
        body: _paymentMethodView(context),
      ),
    );
  }

  Widget _paymentMethodView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<CardBloc, CardState>(
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
        ),
        BlocListener<CheckoutBloc, CheckoutState>(
          listener: (context, state){
            if(state.status == CheckoutStatus.selectedCardSuccess){
              Navigator.pushNamed(context, Routes.confirmPaymentScreen);
            }
          },
        )
      ],
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              headText(context, "Payment Methods"),
              _paymentList(context),
              _confirmPaymentButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentList(BuildContext context){
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state){
        if(state.cards.isEmpty){
          return Expanded(
            child: Center(
              child: Text(
                "No E-Wallet Found",
                style: GoogleFonts.urbanist(fontSize: 18.sp),
              ),
            ),
          );
        }else{
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 2.h),
              child: ListView(
                children: _paymentListData(context, state),
              ),
            ),
          );
        }
      },
    );
  }

  List<Widget> _paymentListData(BuildContext context, CardState state){
    List<Widget> widget = <Widget>[];

    for(var card in state.cards){
      widget.add(
          _paymentListItem(context, card)
      );
    }

    return widget;
  }

  Widget _paymentListItem(BuildContext context, CardModel card){
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: (){
          if(!card.isDefault!){
            BlocProvider.of<CardBloc>(context).add(CardDefaultChanged(card.id!));
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
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
              Container(
                  height: 2.h,
                  width: 2.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.backgroundColor,
                      border: Border.all(color: AppTheme.primaryColor)
                  ),
                  child: card.isDefault!
                      ? _choosenShipping()
                      : const SizedBox()
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _choosenShipping(){
    return Center(
      child: Container(
        height: 1.25.h,
        width: 1.25.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _confirmPaymentButton(BuildContext context){
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state){
        return AppButton(
          onPressed: (){
            if(state.card != null){
              BlocProvider.of<CheckoutBloc>(context).add(CheckoutPaymentSelected(state.card!));
            }else{
              debugPrint("sadsds");
            }
          },
          text: "Confirm Payment",
        );
      },
    );
  }
}