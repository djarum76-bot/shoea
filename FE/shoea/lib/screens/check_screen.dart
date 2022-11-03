import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shoea/bloc/user/user_bloc.dart';
import 'package:shoea/utils/routes.dart';

class CheckScreen extends StatelessWidget{
  const CheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _checkView(context),
    );
  }

  Widget _checkView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state){
        if(state.user == null){
          EasyLoading.show(status: "Loading");
        }else{
          if(state.user!.picture!.valid == false){
            EasyLoading.dismiss();
            Navigator.pushNamedAndRemoveUntil(context, Routes.fillProfileScreen, (route) => false);
          }else if(state.user!.pin!.valid == false){
            EasyLoading.dismiss();
            Navigator.pushNamedAndRemoveUntil(context, Routes.createPinScreen, (route) => false);
          }else{
            EasyLoading.dismiss();
            Navigator.pushNamedAndRemoveUntil(context, Routes.navbarScreen, (route) => false);
          }
        }
      },
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.black,
      ),
    );
  }
}