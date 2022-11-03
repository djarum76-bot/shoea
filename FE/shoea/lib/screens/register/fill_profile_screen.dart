import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formz/formz.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/user/user_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/cubit/date_cubit.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/modal_dialog.dart';
import 'package:shoea/utils/routes.dart';

class FillProfileScreen extends StatefulWidget{
  const FillProfileScreen({super.key});

  @override
  State<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _date;
  late TextEditingController _phone;
  late SingleValueDropDownController _gender;
  late String _birth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = TextEditingController();
    _date = TextEditingController();
    _phone = TextEditingController();
    _gender = SingleValueDropDownController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _name.dispose();
    _date.dispose();
    _phone.dispose();
    _gender.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DateCubit(DateTime.now()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);

            if(!currentFocus.hasPrimaryFocus){
              currentFocus.unfocus();
            }
          },
          child: _fillProfileView(context),
        ),
      ),
    );
  }

  Widget _fillProfileView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state){
        if(state.status.isSubmissionFailure){
          EasyLoading.dismiss();
          ModalDialog.dangerDialog(context);
        }
        if(state.status.isSubmissionSuccess){
          EasyLoading.dismiss();
          Navigator.pushNamed(context, Routes.createPinScreen);
        }
        if(state.status.isSubmissionInProgress){
          EasyLoading.show(status: "Saving Your Data");
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0.5.h),
          child: Column(
            children: [
              headText(context, "Fill Your Profile"),
              _fillForm(context),
              _finishButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _fillForm(BuildContext context){
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.5.h),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _photoForm(context),
              SizedBox(height: 3.h,),
              _nameInput(),
              SizedBox(height: 1.5.h,),
              _dateInput(context),
              SizedBox(height: 1.5.h,),
              _phoneInput(),
              SizedBox(height: 1.5.h,),
              _genderInput()
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoForm(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Align(
        alignment: Alignment.topCenter,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state){
            return Stack(
              children: [
                _photoCircle(state),
                _photoButton(context)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _photoCircle(UserState state){
    return CircleAvatar(
      backgroundImage: state.image == null ? const AssetImage("asset/user/download.png") : FileImage(File(state.image!)) as ImageProvider,
      radius: 8.h,
    );
  }

  Widget _photoButton(BuildContext context){
    return Positioned(
      bottom: 0.5.h,
      right: 3.w,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: (){
          BlocProvider.of<UserBloc>(context).add(FillUserImage());
        },
        child: Container(
          decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(6)
          ),
          width: 3.h,
          height: 3.h,
          child: const Center(
            child: Icon(
              LineIcons.pen,
              color: AppTheme.onPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameInput(){
    return TextFormField(
      controller: _name,
      keyboardType: TextInputType.name,
      style: GoogleFonts.urbanist(),
      decoration: AppTheme.inputDecoration("Name", 12),
      validator: ValidationBuilder().build(),
    );
  }

  Widget _dateInput(BuildContext context){
    return BlocBuilder<DateCubit, DateTime>(
      builder: (context, state){
        return TextFormField(
          controller: _date,
          readOnly: true,
          style: GoogleFonts.urbanist(),
          decoration: AppTheme.inputSuffixDecoration(Ionicons.calendar_outline, "Date", 12),
          validator: ValidationBuilder().build(),
          onTap: ()async{
            final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: state,
                firstDate: DateTime(1900),
                lastDate: DateTime.now()
            );

            if(!mounted) return;
            if(picked != null){
              context.read<DateCubit>().changeDate(picked);
              _birth = picked.toIso8601String();
              _date.text = DateFormat('d MMM yyyy').format(picked);
            }
          },
        );
      },
    );
  }

  Widget _phoneInput(){
    return TextFormField(
      controller: _phone,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.urbanist(),
      decoration: AppTheme.inputDecoration("Phone", 12),
      validator: ValidationBuilder().phone("Invalid Phone Number").build(),
    );
  }

  Widget _genderInput(){
    return DropDownTextField(
      controller: _gender,
      validator: ValidationBuilder().build(),
      textStyle: GoogleFonts.urbanist(),
      textFieldDecoration: AppTheme.inputDecoration("Gender", 12),
      dropDownList: const [
        DropDownValueModel(
          name: Constants.male,
          value: Constants.male
        ),
        DropDownValueModel(
          name: Constants.female,
          value: Constants.female,
        )
      ],
      dropDownItemCount: 2,
    );
  }

  Widget _finishButton(){
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state){
        return AppButton(
          onPressed: (){
            if(state.image == null){
              ModalDialog.dangerDialog(context);
            }else{
              if(_formKey.currentState!.validate()){
                BlocProvider.of<UserBloc>(context).add(
                    FillUserData(state.image!, _name.text, _birth, _phone.text, _gender.dropDownValue!.name)
                );
              }
            }
          },
          text: "Continue",
        );
      },
    );
  }
}