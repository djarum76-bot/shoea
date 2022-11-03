import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/cart/cart_bloc.dart';
import 'package:shoea/bloc/checkout/checkout_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/checkout_item.dart';
import 'package:shoea/components/widget/head_icon_text.dart';
import 'package:shoea/components/widget/vertical_barrier.dart';
import 'package:shoea/models/cart_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/currency_format.dart';
import 'package:shoea/utils/routes.dart';
import 'package:shoea/utils/total_carts_price.dart';

class CartScreen extends StatelessWidget{
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context)..add(CartFetched()),
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<CartBloc, CartState>(
              listener: (context, state){
                if(state.status.isSubmissionFailure){
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(content: Text("Error"))
                    );
                }
                if(state.status.isSubmissionSuccess){
                  EasyLoading.dismiss();
                  Navigator.pop(context);
                }
                if(state.status.isSubmissionInProgress){
                  EasyLoading.show(status: "Deleting...",);
                }
              },
            ),
            BlocListener<CheckoutBloc, CheckoutState>(
              listener: (context, state){
                if(state.status == CheckoutStatus.fetchCartSuccess){
                  Navigator.pushNamed(context, Routes.checkoutScreen);
                }
              },
            )
          ],
          child: _cartView(context),
        ),
      ),
    );
  }

  Widget _cartView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state){
        if(state.carts.isEmpty){
          return SafeArea(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  _cartHeader(context),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Please Make a Purchase",
                        style: GoogleFonts.urbanist(fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }else{
          return SafeArea(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  _cartHeader(context),
                  _listCartItem(context, state),
                  _priceAndCheckoutButton(context, state.carts)
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _cartHeader(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(1.5.h),
      child: headIconText(context, "My Cart"),
    );
  }

  Widget _listCartItem(BuildContext context, CartState state){
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.5.h),
        child: ListView.builder(
          itemCount: state.carts.length,
          itemBuilder: (context, index){
            CartModel cart = state.carts[index];
            return _cartItem(size, index, context, cart);
          },
        ),
      ),
    );
  }

  Widget _cartItem(Size size, int index, BuildContext context, CartModel cart){
    return Container(
      width: size.width,
      margin: EdgeInsets.only(top: index == 0 ? 0 :1.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _cartImage(cart),
          _cartInformation(context, cart)
        ],
      ),
    );
  }

  Widget _cartImage(CartModel cart){
    return Container(
      height: 14.5.h,
      width: 16.h,
      margin: EdgeInsets.only(right: 1.h),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage("${Constants.baseURL}/${cart.image}"),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(20)
      ),
    );
  }

  Widget _cartInformation(BuildContext context, CartModel cart){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cartNameDelete(context, cart),
          SizedBox(height: 2.h,),
          _cartColorSize(cart),
          SizedBox(height: 2.h,),
          _cartPriceQty(context, cart)
        ],
      ),
    );
  }

  Widget _cartNameDelete(BuildContext context, CartModel cart){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            cart.title!,
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        InkWell(
          onTap: (){
            _deleteModal(context, cart);
          },
          borderRadius: BorderRadius.circular(200),
          child: SizedBox(
            width: 4.h,
            height: 4.h,
            child: const Icon(LineIcons.trash),
          ),
        )
      ],
    );
  }

  Future<void> _deleteModal(BuildContext context, CartModel cart)async{
    return showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )
        ),
        builder: (context){
          return _deleteBottomSheet(context, cart);
        }
    );
  }

  Widget _deleteBottomSheet(BuildContext context, CartModel cart){
    return Container(
      decoration: const BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
      ),
      padding: EdgeInsets.all(1.5.h),
      height: 32.5.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Remove From Cart?",
            style: GoogleFonts.urbanist(fontSize: 18.5.sp, fontWeight: FontWeight.w700),
          ),
          const Divider(color: AppTheme.formColor, thickness: 2,),
          CheckoutItem(isList: false, cart: cart,),
          const Divider(color: AppTheme.formColor, thickness: 2,),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  height: 5.h,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  text: "Cancel",
                  textColor: AppTheme.primaryColor,
                  backgroundColor: AppTheme.formColor,
                ),
              ),
              SizedBox(width: 3.w,),
              Expanded(
                child: AppButton(
                  height: 5.h,
                  onPressed: (){
                    BlocProvider.of<CartBloc>(context).add(CartDeleted(cart.id!));
                  },
                  text: "Yes, Remove",
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _cartColorSize(CartModel cart){
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
          cart.size.toString(),
          style: GoogleFonts.urbanist(color: AppTheme.grayColor),
        )
      ],
    );
  }

  Widget _cartPriceQty(BuildContext context, CartModel cart){
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
        Container(
          decoration: BoxDecoration(
              color: AppTheme.formColor,
              borderRadius: BorderRadius.circular(12)
          ),
          padding: EdgeInsets.all(1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: (){
                  BlocProvider.of<CartBloc>(context).add(CartDecreasedQty(cart.id!, cart.qty!));
                },
                borderRadius: BorderRadius.circular(200),
                child: Icon(Ionicons.remove, size: 2.h,),
              ),
              SizedBox(width: 3.w,),
              Text(
                cart.qty.toString(),
                style: GoogleFonts.urbanist(fontSize: 16.5.sp),
              ),
              SizedBox(width: 3.w,),
              InkWell(
                onTap: (){
                  BlocProvider.of<CartBloc>(context).add(CartIncreasedQty(cart.id!, cart.qty!));
                },
                borderRadius: BorderRadius.circular(200),
                child: Icon(Ionicons.add, size: 2.h,),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _priceAndCheckoutButton(BuildContext context, List<CartModel> carts){
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        width: size.width,
        height: 9.h,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.formColor)
          )
        ),
        padding: EdgeInsets.all(1.5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Total Price",
                    style: GoogleFonts.urbanist(),
                  ),
                  Text(
                    CurrencyFormat.convertToIdr(totalCartsPrice(carts)),
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.sp),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            Expanded(
              child: AppButton(
                onPressed: (){
                  BlocProvider.of<CheckoutBloc>(context).add(CheckoutOrder(carts));
                },
                text: "Checkout",
              ),
            )
          ],
        ),
      ),
    );
  }
}