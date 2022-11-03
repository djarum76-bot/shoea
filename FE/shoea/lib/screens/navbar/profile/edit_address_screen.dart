import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/address/address_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/models/address_model.dart';
import 'package:shoea/models/ongkir/city_model.dart';
import 'package:shoea/models/ongkir/province_model.dart';
import 'package:shoea/repositories/address_repository.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/modal_dialog.dart';

class EditAddresScreen extends StatefulWidget{
  const EditAddresScreen({super.key, required this.address});
  final AddressModel address;

  @override
  State<EditAddresScreen> createState() => _EditAddresScreenState();
}

class _EditAddresScreenState extends State<EditAddresScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  late TextEditingController _name;
  late TextEditingController _detail;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = TextEditingController(text: widget.address.addressName!);
    _detail = TextEditingController(text: widget.address.addressDetail!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _name.dispose();
    _detail.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _addAddressView(context),
    );
  }

  Widget _addAddressView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state){
        if(state.status == AddressStatus.error){
          EasyLoading.dismiss();
          ModalDialog.dangerDialog(context);
        }
        if(state.status == AddressStatus.updateMapSuccess){
          EasyLoading.dismiss();
          Navigator.pop(context);
          Navigator.pop(context);
        }
        if(state.status == AddressStatus.updateLoading){
          EasyLoading.show(status: "Updating...",);
        }
      },
      child: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              _editAddressTitle(),
              _editAddressMap(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _editAddressTitle(){
    return Padding(
      padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
      child: headText(context, "Edit Address"),
    );
  }

  Widget _editAddressMap(BuildContext context){
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.address.lat!, widget.address.lng!),
            zoom: 14.4746,
          ),
          markers: {
            Marker(
              markerId: MarkerId(LatLng(widget.address.lat!, widget.address.lng!).toString()),
              position: LatLng(widget.address.lat!, widget.address.lng!),
              icon: BitmapDescriptor.defaultMarker,
              onTap: (){
                _mapModal(context);
              }
            )
          },
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  Future<void> _mapModal(BuildContext context)async{
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )
        ),
        builder: (context){
          return _mapBottomSheet(context);
        }
    );
  }

  Widget _mapBottomSheet(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
      ),
      padding: EdgeInsets.all(1.5.h),
      height: 75.h,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Address Details",
                  style: GoogleFonts.urbanist(fontSize: 18.5.sp, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 1.h,),
              const Divider(color: AppTheme.formColor, thickness: 2,),
              SizedBox(height: 1.h,),
              Text(
                "Address Name",
                style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.5.sp),
                maxLines: 1,
              ),
              SizedBox(height: 1.h,),
              TextFormField(
                controller: _name,
                decoration: AppTheme.inputDecoration("Fill Address Name Here", 12),
                keyboardType: TextInputType.name,
                validator: ValidationBuilder().build(),
              ),
              SizedBox(height: 2.h,),
              Text(
                "Province",
                style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.5.sp),
                maxLines: 1,
              ),
              SizedBox(height: 1.h,),
              DropdownSearch<ProvinceModel>(
                asyncItems: (String filter) => AddressRepository().getAllProvince(),
                itemAsString: (ProvinceModel province) => province.province!,
                selectedItem: widget.address.province!,
                onChanged: (ProvinceModel? data){
                  BlocProvider.of<AddressBloc>(context).add(ProvinceSelected(data!));
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: AppTheme.inputDecoration("Select Address Province", 12),
                ),
                validator: (ProvinceModel? province){
                  if(province == null){
                    return "Require Field";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 2.h,),
              Text(
                "City",
                style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.5.sp),
                maxLines: 1,
              ),
              SizedBox(height: 1.h,),
              BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state){
                  return DropdownSearch<CityModel>(
                    asyncItems: (String filter) => AddressRepository().getAllCityById(state.selectedProvince?.provinceId ?? widget.address.province!.provinceId!),
                    itemAsString: (CityModel city) => city.cityName!,
                    selectedItem: widget.address.city!,
                    onChanged: (CityModel? city){
                      BlocProvider.of<AddressBloc>(context).add(CitySelected(city!));
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: AppTheme.inputDecoration("Select Address City", 12),
                    ),
                    validator: (CityModel? city){
                      if(city == null){
                        return "Require Field";
                      }else{
                        return null;
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 2.h,),
              Text(
                "Address Details",
                style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.5.sp),
                maxLines: 1,
              ),
              SizedBox(height: 1.h,),
              TextFormField(
                controller: _detail,
                decoration: AppTheme.inputDecoration("Fill Address Details Here", 12),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: ValidationBuilder().build(),
              ),
              SizedBox(height: 11.h,),
              BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state){
                  return AppButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        BlocProvider.of<AddressBloc>(context).add(
                            AddressUpdated(
                                widget.address.id!,
                                state.selectedProvince?.provinceId ?? widget.address.province!.provinceId!,
                                state.selectedCity?.cityId ?? widget.address.city!.cityId!,
                                _name.text,
                                _detail.text
                            )
                        );
                      }
                    },
                    text: "Update",
                  );
                },
              ),
              SizedBox(height: 1.h,),
            ],
          ),
        ),
      ),
    );
  }
}