import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget appIcon(){
  return Align(
    alignment: Alignment.center,
    child: Text(
      "S",
      style: GoogleFonts.permanentMarker(fontSize: 45.sp),
    ),
  );
}