import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:random_string/random_string.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/checkout/checkout_bloc.dart';
import 'package:shoea/bloc/order/order_bloc.dart';
import 'package:shoea/bloc/user/user_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/cubit/navbar_cubit.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/routes.dart';

class ConfirmPaymentScreen extends StatefulWidget{
  const ConfirmPaymentScreen({super.key});

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pin = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _confirmPaymentScreen(context),
    );
  }

  Widget _confirmPaymentScreen(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state){
        if(state.status == OrderStatus.addSuccess){
          _orderSuccess(context);
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              headText(context, "Enter Your PIN"),
              _pinField(context),
              _payButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinField(BuildContext context){
    return Expanded(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Enter your PIN to confirm payment",
              style: GoogleFonts.urbanist(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h,),
            PinCodeTextField(
              length: 4,
              obscureText: true,
              pinTheme: PinTheme(
                selectedColor: AppTheme.primaryColor,
                activeColor: AppTheme.primaryColor,
                shape: PinCodeFieldShape.box,
                fieldHeight: 10.h,
                fieldWidth: 10.h,
                borderRadius: BorderRadius.circular(16),
              ),
              keyboardType: TextInputType.number,
              backgroundColor: AppTheme.backgroundColor,
              animationDuration: const Duration(milliseconds: 300),
              controller: _pin,
              validator: ValidationBuilder().build(),
              onChanged: (value) {},
              appContext: context,
            )
          ],
        ),
      ),
    );
  }

  Widget _payButton(BuildContext context){
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, user){
        return BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, checkout){
            return AppButton(
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  if(_pin.text == user.user!.pin!.string!){
                    BlocProvider.of<OrderBloc>(context).add(OrderAdded(randomNumeric(8), checkout.carts, checkout.address!.city!.cityId!, checkout.card!, checkout.selectedShipping!.cost![0].etd!));
                  }else{
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                          const SnackBar(content: Text('Wrong PIN'))
                      );
                    _pin.clear();
                  }
                }
              },
              text: "Pay",
            );
          },
        );
      },
    );
  }

  Future<dynamic> _orderSuccess(BuildContext context)async{
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        body: Column(
          children: [
            Icon(
              LineIcons.shoppingCart,
              size: 15.h,
            ),
            Text(
              "Order Successful!",
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.sp),
            ),
            Text(
              "You have successfully made checkout",
              style: GoogleFonts.urbanist(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h,),
            AppButton(
              onPressed: (){
                context.read<NavbarCubit>().changeTab(2);
                Navigator.pushNamedAndRemoveUntil(context, Routes.navbarScreen, (route) => false);
              },
              text: "Thank You",
              height: 5.h,
            ),
            SizedBox(height: 2.h,)
          ],
        )
    ).show();
  }
}