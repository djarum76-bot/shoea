import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/components/widget/vertical_barrier.dart';
import 'package:shoea/models/transaction_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/currency_format.dart';

class TransactionScreen extends StatelessWidget{
  const TransactionScreen({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _transactionView(context),
    );
  }

  Widget _transactionView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
        child: Column(
          children: [
            headText(context, "E-Receipt"),
            _eReceiptBody()
          ],
        ),
      ),
    );
  }

  Widget _eReceiptBody(){
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 3.h),
        child: ListView(
          children: [
            _barcodeEReceipt(),
            _transactionShoeItem(),
            _eReceiptItem("Total", CurrencyFormat.convertToIdr(100000)),
            _eReceiptDetail()
          ],
        ),
      ),
    );
  }

  Widget _barcodeEReceipt(){
    return BarcodeWidget(
      barcode:  Barcode.qrCode(),
      data: transaction.transactionId!.toString(),
    );
  }

  Widget _transactionShoeItem(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.formColor,
          backgroundImage: NetworkImage("${Constants.baseURL}/${transaction.shoe!.image!}"),
          radius: 3.h,
        ),
        title: Text(
          transaction.shoe!.title!,
          style: GoogleFonts.urbanist(fontSize: 19.sp, fontWeight: FontWeight.w600),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color(int.parse(transaction.color!)),
              radius: 1.1.h,
            ),
            SizedBox(width: 1.w,),
            verticalBarrier(),
            SizedBox(width: 1.w,),
            Text(
              "Size ${transaction.size!}",
              style: GoogleFonts.urbanist(color: AppTheme.grayColor),
            ),
            SizedBox(width: 1.w,),
            verticalBarrier(),
            SizedBox(width: 1.w,),
            Text(
              "Qty ${transaction.qty!}",
              style: GoogleFonts.urbanist(color: AppTheme.grayColor),
            )
          ],
        ),
      ),
    );
  }

  Widget _eReceiptItem(String label, String data){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(),
        ),
        Text(
          data,
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _eReceiptDetail(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          _eReceiptItem("Payment Method", transaction.payment!),
          SizedBox(height: 1.h,),
          _eReceiptItem("Date", DateFormat('d MMM yyyy h:mm a').format(transaction.createdAt!)),
          SizedBox(height: 1.h,),
          _eReceiptItem("Transaction ID", transaction.transactionId!.toString()),
        ],
      ),
    );
  }
}