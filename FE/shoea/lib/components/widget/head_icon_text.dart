import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget headIconText(BuildContext context, String text){
  final size = MediaQuery.of(context).size;
  return SizedBox(
    width: size.width,
    height: 3.5.h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "S",
          style: GoogleFonts.permanentMarker(fontSize: 19.5.sp),
        ),
        SizedBox(width: 2.w,),
        Text(
          text,
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 20.sp),
        )
      ],
    ),
  );
}