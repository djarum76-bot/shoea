import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget headBlocText({required BuildContext context, required String text, required void Function()? onTap}){
  final size = MediaQuery.of(context).size;
  return SizedBox(
    width: size.width,
    height: 3.5.h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(200),
          child: const Icon(LineIcons.arrowLeft),
        ),
        SizedBox(width: 3.w,),
        Text(
          text,
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 20.sp),
        )
      ],
    ),
  );
}