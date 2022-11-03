import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/routes.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), ()async{
      if(StorageService.box.read(Constants.isSkipIntro) == null){
        Navigator.pushNamedAndRemoveUntil(context, Routes.onBoardingScreen, (route) => false);
      }else{
        if(StorageService.box.read(Constants.token) == null){
          Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
        }else{
          if(JwtDecoder.isExpired(StorageService.box.read(Constants.token))){
            Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
          }else{
            Navigator.pushNamedAndRemoveUntil(context, Routes.checkScreen, (route) => false);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.h),
        child: Stack(
          children: [
            _splashText(),
            _splashLoading()
          ],
        ),
      ),
    );
  }

  Widget _splashText(){
    return Center(
      child: Text(
        "Spatu",
        style: GoogleFonts.urbanist(color: AppTheme.primaryColor, fontSize: 32.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _splashLoading(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: LoadingAnimationWidget.inkDrop(
          color: AppTheme.primaryColor,
          size: 6.h
      ),
    );
  }
}