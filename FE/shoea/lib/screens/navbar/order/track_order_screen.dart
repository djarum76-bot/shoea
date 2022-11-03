import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/components/widget/vertical_barrier.dart';
import 'package:shoea/models/order_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/currency_format.dart';

class TrackOrderScreen extends StatelessWidget{
  const TrackOrderScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _trackOrderScreen(context),
    );
  }

  Widget _trackOrderScreen(BuildContext context){
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            _trackOrderTitle(context),
            _trackOrderItem(context),
            _historyTrackOrder()
          ],
        ),
      ),
    );
  }

  Widget _trackOrderTitle(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
      child: headText(context, "Track Order"),
    );
  }

  Widget _trackOrderItem(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.fromLTRB(1.5.h, 0, 1.5.h, 0),
      margin: EdgeInsets.only(top: 1.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _trackOrderImage(),
          _trackOrderInformation(context)
        ],
      ),
    );
  }

  Widget _trackOrderImage(){
    return Container(
      height: 13.h,
      width: 15.h,
      margin: EdgeInsets.only(right: 1.h),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage("${Constants.baseURL}/${order.shoe!.image!}"),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(20)
      ),
    );
  }

  Widget _trackOrderInformation(BuildContext context){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _trackOrderNameDelete(context),
          SizedBox(height: 2.h,),
          _trackOrderColorSize(),
          SizedBox(height: 2.h,),
          _trackOrderPrice()
        ],
      ),
    );
  }

  Widget _trackOrderNameDelete(BuildContext context){
    return Text(
      order.shoe!.title!,
      style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _trackOrderColorSize(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Color(int.parse(order.color!)),
          radius: 1.1.h,
        ),
        SizedBox(width: 1.w,),
        verticalBarrier(),
        SizedBox(width: 1.w,),
        Text(
          "Size ${order.size!}",
          style: GoogleFonts.urbanist(color: AppTheme.grayColor),
        ),
        SizedBox(width: 1.w,),
        verticalBarrier(),
        SizedBox(width: 1.w,),
        Text(
          "Qty ${order.qty!}",
          style: GoogleFonts.urbanist(color: AppTheme.grayColor),
        )
      ],
    );
  }

  Widget _trackOrderPrice(){
    return Text(
      CurrencyFormat.convertToIdr(order.price! * order.qty!),
      style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.sp),
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _historyTrackOrder(){
    return Expanded(
      child: Stepper(
        controlsBuilder: (context, details){
          return Row(
            children: <Widget>[
              Container(
                child: null,
              ),
              Container(
                child: null,
              ),
            ], // <Widget>[]
          );
        },
        steps: _historyStep(),
      ),
    );
  }

  List<Step> _historyStep(){
    List<Step> steps = <Step>[];

    steps.add(
        Step(
          title: Text('Order in Transit - ${DateFormat('d MMM h:mm a').format(order.createdAt!)}'),
          subtitle: Text("${order.originCity!.cityName!}, ${order.originCity!.province!}"),
          content: const SizedBox(),
        )
    );

    steps.add(
        Step(
          title: Text('Order in Transit - ${DateFormat('d MMM h:mm a').format(order.createdAt!.add(Duration(days: int.parse(order.etd!.split("-").last))))}'),
          subtitle: Text("${order.destinationCity!.cityName!}, ${order.destinationCity!.province!}"),
          content: const SizedBox(),
        )
    );

    return steps;
  }
}