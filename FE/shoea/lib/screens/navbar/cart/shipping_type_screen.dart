import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/checkout/checkout_bloc.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/models/ongkir/shipping_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/currency_format.dart';
import 'package:shoea/utils/estimated_time.dart';

class ShippingTypeScreen extends StatelessWidget{
  const ShippingTypeScreen({super.key, required this.destinationCityID});

  final String destinationCityID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CheckoutBloc>(context)..add(CheckoutShippingTypeFetched(destinationCityID)),
      child: Scaffold(
        body: _shippingTypeView(context),
      ),
    );
  }

  Widget _shippingTypeView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state){
        if(state.status == CheckoutStatus.updateShippingSuccess){
          Navigator.pop(context);
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              headText(context, "Choose Shipping"),
              _shippingList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shippingList(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 2.h),
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state){
            if(state.shippings.isEmpty){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return ListView.builder(
                itemCount: state.shippings.length,
                itemBuilder: (context, index){
                  ShippingModel shipping = state.shippings[index];
                  return _shippingListData(size, context, shipping, state);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _shippingListData(Size size, BuildContext context, ShippingModel shipping, CheckoutState state){
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: (){
          BlocProvider.of<CheckoutBloc>(context).add(CheckoutShippingTypeChanged(shipping));
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: size.width,
          height: 7.5.h,
          padding: EdgeInsets.all(1.h),
          decoration: BoxDecoration(
              border: Border.all(color: state.selectedShipping == shipping ? AppTheme.primaryColor : AppTheme.backgroundColor),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.1.h,
                width: 10.5.w,
                child: CircleAvatar(
                  radius: 1.h,
                  child: const Center(
                    child: Icon(LineIcons.box),
                  ),
                ),
              ),
              SizedBox(width: 2.w,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        shipping.description!,
                        style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.sp),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        EstimatedTime.estimatedTime(shipping.cost![0].etd!),
                        style: GoogleFonts.urbanist(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                  height: 4.h,
                  width: 8.h,
                  child: Center(
                    child: Text(
                      CurrencyFormat.convertToIdr(shipping.cost![0].value!),
                      style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}