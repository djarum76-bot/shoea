import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/auth/auth_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/app_icon.dart';
import 'package:shoea/cubit/obscure_cubit.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/modal_dialog.dart';
import 'package:shoea/utils/routes.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ObscureCubit(),
      child: Scaffold(
        body: _registerView(context),
      ),
    );
  }

  Widget _registerView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state){
        if(state.status == AuthStatus.authError){
          EasyLoading.dismiss();
          ModalDialog.dangerDialog(context);
        }
        if(state.status == AuthStatus.authenticatedNoData){
          EasyLoading.dismiss();
          Navigator.pushNamed(context, Routes.fillProfileScreen);
        }
        if(state.status == AuthStatus.loading){
          EasyLoading.show(status: "Prepare Your New Account");
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(3.h),
          child: ListView(
            children: [
              appIcon(),
              _registerText(),
              _registerForm(),
              _goToRegister(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerText(){
    return Align(
      alignment: Alignment.center,
      child: Text(
        "Create Your Account",
        style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 24.sp),
      ),
    );
  }

  Widget _registerForm(){
    return Container(
      padding: EdgeInsets.only(top: 13.h, bottom: 22.5.h),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _emailInput(),
            SizedBox(height: 1.25.h,),
            _passwordInput(),
            SizedBox(height: 2.5.h,),
            _registerButton()
          ],
        ),
      ),
    );
  }

  Widget _emailInput(){
    return TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.urbanist(),
      decoration: AppTheme.inputPrefixDecoration(LineIcons.envelope, "Email", 20),
      validator: ValidationBuilder().email("Invalid Email").build(),
    );
  }

  Widget _passwordInput(){
    return BlocBuilder<ObscureCubit, bool>(
      builder: (context, state){
        return TextFormField(
          controller: _password,
          keyboardType: TextInputType.text,
          obscureText: state,
          style: GoogleFonts.urbanist(),
          decoration: AppTheme.inputPasswordDecoration(context, state),
          validator: ValidationBuilder().minLength(8,"Enter min 8 character").build(),
        );
      },
    );
  }

  Widget _registerButton(){
    return AppButton(
      text: "Register",
      onPressed: (){
        if(_formKey.currentState!.validate()){
          BlocProvider.of<AuthBloc>(context).add(
            RegisterRequested(_email.text, _password.text)
          );
        }
      },
    );
  }

  Widget _goToRegister(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: GoogleFonts.urbanist(color: const Color(0xFF9e9e9e)),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(
            "Sign in",
            style: GoogleFonts.urbanist(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}