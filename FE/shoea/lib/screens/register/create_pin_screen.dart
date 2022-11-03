import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/user/user_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/modal_dialog.dart';
import 'package:shoea/utils/routes.dart';
import 'package:formz/formz.dart';

class CreatePinScreen extends StatefulWidget{
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pin = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _confirmPaymentScreen(context),
    );
  }

  Widget _confirmPaymentScreen(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state){
        if(state.status.isSubmissionFailure){
          EasyLoading.dismiss();
          ModalDialog.dangerDialog(context);
        }
        if(state.status.isSubmissionSuccess){
          EasyLoading.dismiss();
          _createSuccess(context);
        }
        if(state.status.isSubmissionInProgress){
          EasyLoading.show(status: "Saving Your New PIN");
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              headText(context, "Create New PIN"),
              _pinField(context),
              _finishButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinField(BuildContext context){
    return Expanded(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Add a PIN number to make your account more secure",
              style: GoogleFonts.urbanist(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h,),
            PinCodeTextField(
              length: 4,
              obscureText: true,
              cursorColor: AppTheme.primaryColor,
              pinTheme: PinTheme(
                selectedColor: AppTheme.primaryColor,
                activeColor: AppTheme.primaryColor,
                shape: PinCodeFieldShape.box,
                fieldHeight: 10.h,
                fieldWidth: 10.h,
                borderRadius: BorderRadius.circular(16),
              ),
              keyboardType: TextInputType.number,
              backgroundColor: AppTheme.backgroundColor,
              animationDuration: const Duration(milliseconds: 300),
              controller: _pin,
              validator: ValidationBuilder().build(),
              onChanged: (value) {},
              appContext: context,
            )
          ],
        ),
      ),
    );
  }

  Widget _finishButton(BuildContext context){
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state){
        return AppButton(
          onPressed: (){
            if(_formKey.currentState!.validate()){
              BlocProvider.of<UserBloc>(context).add(
                FillUserPin(_pin.text)
              );
            }
          },
          text: "Finish",
        );
      },
    );
  }

  Future<dynamic> _createSuccess(BuildContext context)async{
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        body: Column(
          children: [
            Icon(
              LineIcons.user,
              size: 15.h,
            ),
            Text(
              "Congratulations!",
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.sp),
            ),
            Text(
              "Your account is ready to use. You will be redirected to the Home page in a few second",
              style: GoogleFonts.urbanist(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h,),
            AppButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, Routes.navbarScreen, (route) => false);
              },
              text: "See You",
              height: 5.h,
            ),
            SizedBox(height: 2.h,)
          ],
        )
    ).show();
  }
}