import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/service/storage_service.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/routes.dart';

class OnBoardingScreen extends StatelessWidget{
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _onBoardingView(context),
    );
  }

  Widget _onBoardingView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("asset/onboarding/onboarding.jpeg"),
          fit: BoxFit.cover
        )
      ),
      child: Stack(
        children: [
          _onBoardingShadow(size),
          _onBoardingText(size, context)
        ],
      ),
    );
  }

  Widget _onBoardingShadow(Size size){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size.width,
        height: size.height * 0.6,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black
            ]
          )
        ),
      ),
    );
  }

  Widget _onBoardingText(Size size, BuildContext context){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.h),
        width: size.width,
        height: size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to",
              style: GoogleFonts.urbanist(color: AppTheme.backgroundColor, fontWeight: FontWeight.w600, fontSize: 22.sp),
            ),
            Text(
              "Shoea",
              style: GoogleFonts.urbanist(color: AppTheme.backgroundColor, fontWeight: FontWeight.w700, fontSize: 32.sp),
            ),
            Text(
              "The best shoes e-commerce app of the century for your fashion",
              style: GoogleFonts.urbanist(color: AppTheme.backgroundColor, fontWeight: FontWeight.w500, fontSize: 18.sp),
            ),
            SizedBox(height: 0.75.h,),
            AppButton(
              text: "Next",
              onPressed: (){
                StorageService.box.write(Constants.isSkipIntro, true);
                Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
              },
              backgroundColor: AppTheme.backgroundColor,
              textColor: AppTheme.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}