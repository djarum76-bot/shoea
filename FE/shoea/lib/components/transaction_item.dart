import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/models/transaction_model.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/currency_format.dart';
import 'package:shoea/utils/routes.dart';
import 'package:shoea/utils/screen_argument.dart';

class TransactionItem extends StatelessWidget{
  const TransactionItem({super.key, required this.index, required this.transaction});

  final int index;
  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
          context,
          Routes.transactionScreen,
          arguments: ScreenArgument<TransactionModel>(transaction)
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: index == 0 ? 0 : 1.5.h),
        padding: EdgeInsets.all(1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage("${Constants.baseURL}/${transaction.shoe!.image!}"),
            ),
            SizedBox(width: 2.w,),
            SizedBox(
              width: 55.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction.shoe!.title!,
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  Text(
                    DateFormat('d MMM yyyy h:mm a').format(transaction.createdAt!),
                    style: GoogleFonts.urbanist(),
                  )
                ],
              ),
            ),
            Expanded(
              child: Text(
                CurrencyFormat.convertToIdr(transaction.price! * transaction.qty!),
                style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 17.5.sp),
                maxLines: 1,
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}