import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/components/widget/vertical_barrier.dart';
import 'package:shoea/models/cart_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/currency_format.dart';

class CheckoutItem extends StatelessWidget{
  const CheckoutItem({super.key, required this.isList, required this.cart});

  final bool isList;
  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: EdgeInsets.only(bottom: isList ? 1.5.h : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _checkoutImage(),
          _checkoutInformation(context)
        ],
      ),
    );
  }

  Widget _checkoutImage(){
    return Container(
      height: 13.h,
      width: 15.h,
      margin: EdgeInsets.only(right: 1.h),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage("${Constants.baseURL}/${cart.image!}"),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(20)
      ),
    );
  }

  Widget _checkoutInformation(BuildContext context){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _checkoutNameDelete(context),
          SizedBox(height: 2.h,),
          _checkoutColorSize(),
          SizedBox(height: 2.h,),
          _checkoutPriceQty()
        ],
      ),
    );
  }

  Widget _checkoutNameDelete(BuildContext context){
    return Text(
      cart.title!,
      style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _checkoutColorSize(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Color(int.parse(cart.color!)),
          radius: 1.1.h,
        ),
        SizedBox(width: 1.w,),
        verticalBarrier(),
        SizedBox(width: 1.w,),
        Text(
          "42",
          style: GoogleFonts.urbanist(color: AppTheme.grayColor),
        )
      ],
    );
  }

  Widget _checkoutPriceQty(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            CurrencyFormat.convertToIdr(cart.price! * cart.qty!),
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.sp),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        CircleAvatar(
          backgroundColor: AppTheme.formColor,
          radius: 2.h,
          child: Center(
            child: Text(
              cart.qty.toString(),
              style: GoogleFonts.urbanist(fontSize: 16.5.sp),
            ),
          ),
        )
      ],
    );
  }
}