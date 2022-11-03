import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:formz/formz.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/card/card_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/modal_dialog.dart';

class AddNewCardScreen extends StatefulWidget{
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _number;
  late TextEditingController _date;
  late TextEditingController _cvv;
  late TextEditingController _card;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _number = TextEditingController();
    _date = TextEditingController();
    _cvv = TextEditingController();
    _card = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _name.dispose();
    _number.dispose();
    _date.dispose();
    _cvv.dispose();
    _card.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _addNewCardView(context),
    );
  }

  Widget _addNewCardView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<CardBloc, CardState>(
      listener: (context, state){
        if(state.status.isSubmissionFailure){
          EasyLoading.dismiss();
          ModalDialog.dangerDialog(context);
        }
        if(state.status.isSubmissionSuccess){
          EasyLoading.dismiss();
          Navigator.pop(context);
        }
        if(state.status.isSubmissionInProgress){
          EasyLoading.show(status: "Adding...",);
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              headText(context, "Add New Card"),
              _creditCardWidget(context),
              _addButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _creditCardWidget(BuildContext context){
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 2.h, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CreditCardWidget(
                cardNumber: _number.text,
                expiryDate: _date.text,
                cardHolderName: _card.text,
                cvvCode: _cvv.text,
                showBackView: false,
                isHolderNameVisible: true,
                onCreditCardWidgetChange: (creditCardBrand){},
                cardType: CardType.mastercard,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.75.h),
                child: Form(
                  key: _formKey1,
                  child: TextFormField(
                    controller: _name,
                    decoration: AppTheme.creditCardHolderDecoration("Card Bank Name"),
                    validator: ValidationBuilder().build(),
                  ),
                ),
              ),
              CreditCardForm(
                formKey: _formKey2,
                obscureCvv: true,
                obscureNumber: true,
                cardNumber: _number.text,
                cvvCode: _cvv.text,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: _card.text,
                expiryDate: _date.text,
                themeColor: AppTheme.primaryColor,
                textColor: AppTheme.primaryColor,
                cardHolderValidator: ValidationBuilder().build(),
                cardNumberDecoration: AppTheme.creditCardDecoration("Number", "XXXX XXXX XXXX XXXX"),
                expiryDateDecoration: AppTheme.creditCardDecoration("Expired Date", "XX/XX"),
                cvvCodeDecoration: AppTheme.creditCardDecoration("CVV", "XXX"),
                cardHolderDecoration: AppTheme.creditCardHolderDecoration("Card Holder"),
                onCreditCardModelChange: onCreditCardModelChange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context){
    return AppButton(
      onPressed: (){
        if(_formKey1.currentState!.validate() && _formKey2.currentState!.validate()){
          BlocProvider.of<CardBloc>(context).add(CardAdded(_name.text, _number.text, _date.text, _cvv.text, _card.text));
        }
      },
      text: "Add",
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      _number.text = creditCardModel!.cardNumber;
      _date.text = creditCardModel.expiryDate;
      _card.text = creditCardModel.cardHolderName;
      _cvv.text = creditCardModel.cvvCode;
    });
  }
}