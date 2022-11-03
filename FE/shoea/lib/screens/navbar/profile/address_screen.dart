import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/address/address_bloc.dart';
import 'package:shoea/bloc/checkout/checkout_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/models/address_model.dart';
import 'package:shoea/utils/routes.dart';
import 'package:shoea/utils/screen_argument.dart';

class AddressScreen extends StatelessWidget{
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AddressBloc>(context)..add(AddressFetched()),
      child: Scaffold(
        body: _addressView(context),
      ),
    );
  }

  Widget _addressView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state){
        if(state.status == AddressStatus.updateDefaultSuccess){
          BlocProvider.of<CheckoutBloc>(context).add(CheckoutShippingAddressChanged(state.address!));
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              headText(context, "Address"),
              _isHaveAddress(context),
              _addressButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _isHaveAddress(BuildContext context){
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state){
        switch(state.status){
          case AddressStatus.fetchLoading:
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case AddressStatus.updateLoading:
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case AddressStatus.fetchSuccess:
            switch(state.addresses){
              case <AddressModel>[]:
                return Expanded(
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
                return _addressList(context, state);
            }
          case AddressStatus.updateDefaultSuccess:
            return _addressList(context, state);
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
    );
  }

  Widget _addressList(BuildContext context, AddressState state){
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 2.h, bottom: 0.5.h),
        child: ListView.builder(
          itemCount: state.addresses.length,
          itemBuilder: (context, index){
            AddressModel address = state.addresses[index];
            return _addressListItem(size, context, address);
          },
        ),
      ),
    );
  }

  Widget _addressListItem(Size size, BuildContext context, AddressModel address){
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
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
              child: GestureDetector(
                onTap: (){
                  if(!address.isDefault!){
                    BlocProvider.of<AddressBloc>(context).add(AddressDefaultChanged(address.id!));
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        address.isDefault! ? "${address.addressName!} (Default)" : address.addressName!,
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
            ),
            SizedBox(
              height: 2.h,
              width: 2.h,
              child: Center(
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, Routes.editAddressScreen);
                  },
                  borderRadius: BorderRadius.circular(200),
                  child: const Icon(LineIcons.pen),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _addressButton(BuildContext context){
    return AppButton(
      onPressed: (){
        Navigator.pushNamed(
            context,
            Routes.addAddressScreen,
            arguments: ScreenArgument<bool>(false)
        );
      },
      text: "Add New Address",
    );
  }
}