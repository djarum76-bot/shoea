import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/address/address_bloc.dart';
import 'package:shoea/bloc/checkout/checkout_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/models/address_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/modal_dialog.dart';
import 'package:shoea/utils/routes.dart';

class ShippingAddressScreen extends StatelessWidget{
  const ShippingAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AddressBloc>(context)..add(AddressFetched()),
      child: Scaffold(
        body: _shippingAddressView(context),
      ),
    );
  }

  Widget _shippingAddressView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state){
        if(state.status == AddressStatus.error){
          EasyLoading.dismiss();
          ModalDialog.dangerDialog(context);
        }
        if(state.status == AddressStatus.updateDefaultSuccess){
          EasyLoading.dismiss();
          BlocProvider.of<CheckoutBloc>(context).add(CheckoutShippingAddressChanged(state.address!));
          Navigator.pop(context);
        }
        if(state.status == AddressStatus.fetchSuccess){
          EasyLoading.dismiss();
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              headText(context, "Shipping Address"),
              _addressList(context),
              SizedBox(height: 2.h,),
              _addAddressButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressList(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state){
          switch (state.status){
            case AddressStatus.fetchLoading:
              return SizedBox(
                width: double.infinity,
                height: 80.h,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case AddressStatus.updateLoading:
              return SizedBox(
                width: double.infinity,
                height: 80.h,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case AddressStatus.fetchSuccess:
              switch (state.addresses){
                case <AddressModel>[]:
                  return SizedBox(
                    width: double.infinity,
                    height: 80.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Address Found",
                          style: GoogleFonts.urbanist(fontSize: 18.sp),
                        ),
                        Text(
                          "Add Your Address Below",
                          style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.sp),
                        )
                      ],
                    ),
                  );
                default:
                  return Wrap(
                    children: _addressListData(context, state),
                  );
              }
            case AddressStatus.updateDefaultSuccess:
              return Wrap(
                children: _addressListData(context, state),
              );
            default:
              return SizedBox(
                width: double.infinity,
                height: 80.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message ?? "Error",
                      style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.sp),
                    )
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  List<Widget> _addressListData(BuildContext context, AddressState state){
    final size = MediaQuery.of(context).size;
    List<Widget> widget = <Widget>[];

    for(var address in state.addresses){
      widget.add(
        _addressListItem(size, context, address)
      );
    }

    return widget;
  }

  Widget _addressListItem(Size size, BuildContext context, AddressModel address){
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: (){
          if(!address.isDefault!){
            BlocProvider.of<AddressBloc>(context).add(AddressDefaultChanged(address.id!));
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: size.width,
          height: 7.5.h,
          padding: EdgeInsets.all(1.h),
          decoration: BoxDecoration(
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
                        address.addressName!,
                        style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.sp),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        address.addressDetail!,
                        style: GoogleFonts.urbanist(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 2.h,
                width: 2.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.backgroundColor,
                  border: Border.all(color: AppTheme.primaryColor)
                ),
                child: address.isDefault!
                  ? _choosenShipping()
                  : const SizedBox()
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _choosenShipping(){
    return Center(
      child: Container(
        height: 1.25.h,
        width: 1.25.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _addAddressButton(BuildContext context){
    return AppButton(
      onPressed: (){
        Navigator.pushNamed(context, Routes.addAddressScreen);
      },
      text: "Add New Address",
      textColor: AppTheme.primaryColor,
      backgroundColor: AppTheme.formColor,
    );
  }
}