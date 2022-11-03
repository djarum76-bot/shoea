import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/checkout/checkout_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/checkout_item.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/models/cart_model.dart';
import 'package:shoea/models/ongkir/shipping_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/currency_format.dart';
import 'package:shoea/utils/estimated_time.dart';
import 'package:shoea/utils/routes.dart';
import 'package:shoea/utils/screen_argument.dart';

class CheckoutScreen extends StatelessWidget{
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CheckoutBloc>(context)..add(CheckoutShippingAddressFetched()),
      child: Scaffold(
        body: _checkoutView(context),
      ),
    );
  }

  Widget _checkoutView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(1.5.h),
        child: ListView(
          children: [
            headText(context, "Checkout"),
            _shippingAddressTitle(),
            _shippingAddressButton(context),
            _orderTitle(),
            _orderList(),
            _shippingTypeTitle(),
            _shippingTypeButton(context),
            _checkoutTotal(context),
            _paymentButton(context)
          ],
        ),
      ),
    );
  }

  Widget _shippingAddressTitle(){
    return Container(
      margin: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Shipping Address",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
      ),
    );
  }

  Widget _shippingAddressButton(BuildContext context){
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, Routes.shippingAddressScreen);
      },
      borderRadius: BorderRadius.circular(20),
      child: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state){
          return _isShippingHaveChoosen(size, state);
        },
      ),
    );
  }

  Widget _isShippingHaveChoosen(Size size, CheckoutState state){
    if(state.address == null){
      return _shippingAddressChoose(size);
    }else{
      return _shippingAddressChoosen(size, state);
    }
  }

  Widget _shippingAddressChoose(Size size){
    return Container(
      width: size.width,
      height: 7.5.h,
      padding: EdgeInsets.all(1.h),
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryColor),
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
                child: Icon(LineIcons.mapMarker),
              ),
            ),
          ),
          SizedBox(width: 2.w,),
          Expanded(
            child: Text(
              "Choose Shipping Address",
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.sp),
            ),
          ),
          SizedBox(
            height: 4.h,
            width: 4.h,
            child: const Center(
              child: Icon(Icons.arrow_forward_ios),
            ),
          )
        ],
      ),
    );
  }

  Widget _shippingAddressChoosen(Size size, CheckoutState state){
    return Container(
      width: size.width,
      height: 7.5.h,
      padding: EdgeInsets.all(1.h),
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryColor),
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
                child: Icon(LineIcons.mapMarker),
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
                    state.address!.addressName!,
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    state.address!.addressDetail!,
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
            width: 4.h,
            child: const Center(
              child: Icon(LineIcons.pen),
            ),
          )
        ],
      ),
    );
  }

  Widget _orderTitle(){
    return Container(
      margin: EdgeInsets.fromLTRB(0, 2.h, 0, 1.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Order List",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
      ),
    );
  }

  Widget _orderList(){
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state){
        return Wrap(
          children: _orderListData(state.carts),
        );
      },
    );
  }

  List<Widget> _orderListData(List<CartModel> carts){
    List<Widget> widget = <Widget>[];

    for(var cart in carts){
      widget.add(
          CheckoutItem(isList: true, cart: cart,)
      );
    }

    return widget;
  }

  Widget _shippingTypeTitle(){
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0.5.h, 0, 1.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Choose Shipping",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
      ),
    );
  }

  Widget _shippingTypeButton(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state){
        if(state.address == null){
          return InkWell(
            onTap: (){
              ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text("Choose Address First"))
                  );
            },
            borderRadius: BorderRadius.circular(20),
            child: _shippingTypeChoose(size),
          );
        }else{
          if(state.selectedShipping == null){
            return InkWell(
              onTap: (){
                Navigator.pushNamed(
                    context,
                    Routes.shippingTypeScreen,
                    arguments: ScreenArgument<String>(state.address!.city!.cityId!)
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: _shippingTypeChoose(size),
            );
          }else{
            return InkWell(
              onTap: (){
                Navigator.pushNamed(
                    context,
                    Routes.shippingTypeScreen,
                    arguments: ScreenArgument<String>(state.address!.city!.cityId!)
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: _shippingTypeChoosen(size, state.selectedShipping!),
            );
          }
        }
      },
    );
  }

  Widget _shippingTypeChoose(Size size){
    return Container(
      width: size.width,
      height: 7.5.h,
      padding: EdgeInsets.all(1.h),
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryColor),
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
                child: Icon(LineIcons.car),
              ),
            ),
          ),
          SizedBox(width: 2.w,),
          Expanded(
            child: Text(
              "Choose Shipping Type",
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.sp),
            ),
          ),
          SizedBox(
            height: 4.h,
            width: 4.h,
            child: const Center(
              child: Icon(Icons.arrow_forward_ios),
            ),
          )
        ],
      ),
    );
  }

  Widget _shippingTypeChoosen(Size size, ShippingModel shipping){
    return Container(
      width: size.width,
      height: 7.5.h,
      padding: EdgeInsets.all(1.h),
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryColor),
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
            width: 4.h,
            child: const Center(
              child: Icon(LineIcons.pen),
            ),
          )
        ],
      ),
    );
  }

  Widget _checkoutTotal(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.all(1.h),
      child: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state){
          return Column(
            children: [
              _checkoutMoney("Amount", state.amount),
              _checkoutMoney("Shipping", state.shipping),
              const Divider(thickness: 1, color: AppTheme.formColor,),
              _checkoutMoney("Total", state.total),
            ],
          );
        },
      ),
    );
  }

  Widget _checkoutMoney(String label, int money){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(),
        ),
        Text(
          CurrencyFormat.convertToIdr(money),
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _paymentButton(BuildContext context){
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state){
        return AppButton(
          onPressed: (){
            Navigator.pushNamed(context, Routes.paymentMethodScreen);
            // if(state.address == null){
            //   ScaffoldMessenger.of(context)
            //     ..hideCurrentSnackBar()
            //     ..showSnackBar(
            //         const SnackBar(content: Text("Please choose your address"))
            //     );
            // }else if(state.selectedShipping == null){
            //   ScaffoldMessenger.of(context)
            //     ..hideCurrentSnackBar()
            //     ..showSnackBar(
            //         const SnackBar(content: Text("Please choose shipping type"))
            //     );
            // }else{
            //   Navigator.pushNamed(context, Routes.paymentMethodScreen);
            // }
          },
          text: "Continue to Payment",
        );
      },
    );
  }
}