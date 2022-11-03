import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/cubit/obscure_cubit.dart';
import 'package:shoea/utils/material_color.dart';

class AppTheme{
  static ThemeData theme(){
    return ThemeData(
      primaryColor: primaryColor,
      primarySwatch: createMaterialColor(primaryColor),
      backgroundColor: backgroundColor,
      scaffoldBackgroundColor: backgroundColor,
      textButtonTheme:TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor)
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: createMaterialColor(primaryColor)
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor
      )
    );
  }

  static ButtonStyle elevatedButton(double radius, Color color){
    return ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        )
    );
  }

  static InputDecoration inputDecoration(String hint, double radius){
    return InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: primaryColor)
        ),
        fillColor: formColor,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(),
        contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
    );
  }

  static InputDecoration inputPrefixDecoration(IconData icon, String hint, double radius){
    return InputDecoration(
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: primaryColor)
        ),
        fillColor: formColor,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(),
        contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h)
    );
  }

  static InputDecoration inputSuffixDecoration(IconData icon, String hint, double radius){
    return InputDecoration(
        suffixIcon: Icon(icon),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: primaryColor)
        ),
        fillColor: formColor,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(),
        contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h)
    );
  }

  static InputDecoration inputPasswordDecoration(BuildContext context, bool state){
    return InputDecoration(
        prefixIcon: const Icon(LineIcons.lock),
        suffixIcon: IconButton(
          onPressed: (){
            context.read<ObscureCubit>().obscureUpdate();
          },
          icon: Icon(state ? Ionicons.eye_off_outline : Ionicons.eye_outline),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: primaryColor)
        ),
        fillColor: formColor,
        filled: true,
        hintText: "Password",
        hintStyle: GoogleFonts.urbanist(),
        contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h)
    );
  }

  static InputDecoration reviewDecoration(){
    return InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryColor)
      ),
      hintText: "Fill your review here",
      hintStyle: GoogleFonts.urbanist(),
      contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
    );
  }

  static InputDecoration creditCardDecoration(String label, String hint){
    return InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryColor)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryColor)
      ),
      labelText: label,
      labelStyle: GoogleFonts.urbanist(),
      hintText: hint,
      hintStyle: GoogleFonts.urbanist(color: AppTheme.primaryColor),
      contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
    );
  }

  static InputDecoration creditCardHolderDecoration(String label){
    return InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryColor)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryColor)
      ),
      labelText: label,
      labelStyle: GoogleFonts.urbanist(),
      contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
    );
  }

  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xFF101010);
  static const Color onPrimaryColor = Color(0xFFFBFBFB);
  static const Color formColor = Color(0xFFECECEC);
  static const Color grayColor = Color(0xFF646360);
  static const Color redColor = Color(0xFFf85555);
  static Color skeletonColor = Colors.grey[300]!;
}