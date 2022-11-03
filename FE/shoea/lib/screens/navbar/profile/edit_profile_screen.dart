import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/user/user_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/cubit/date_cubit.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:formz/formz.dart';
import 'package:shoea/utils/modal_dialog.dart';

class EditProfileScreen extends StatefulWidget{
  const EditProfileScreen({super.key, required this.state});

  final UserState state;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _name;
  late TextEditingController _date;
  late TextEditingController _phone;
  late SingleValueDropDownController _gender;
  late String _birth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _birth = widget.state.user!.date!.string!;
    _name = TextEditingController(text: widget.state.user!.name!.string!);
    _date = TextEditingController(text: DateFormat('d MMM yyyy').format(DateTime.parse(widget.state.user!.date!.string!)));
    _phone = TextEditingController(text: widget.state.user!.phone!.string!);
    _gender = SingleValueDropDownController(
      data: DropDownValueModel(
          name: widget.state.user!.gender!.string!,
          value: widget.state.user!.gender!.string!
      )
    );
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
      create: (_) => DateCubit(DateTime.parse(widget.state.user!.date!.string!)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);

            if(!currentFocus.hasPrimaryFocus){
              currentFocus.unfocus();
            }
          },
          child: _editProfileView(context),
        ),
      ),
    );
  }

  Widget _editProfileView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state){
        if(state.status.isSubmissionFailure){
          EasyLoading.dismiss();
          ModalDialog.dangerDialog(context);
        }
        if(state.status.isSubmissionSuccess){
          EasyLoading.dismiss();
          Navigator.pop(context);
        }
        if(state.status.isSubmissionInProgress){
          EasyLoading.show(status: "Updating...",);
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              headText(context, "Edit Profile"),
              _editProfileForm(context),
              _updateButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _editProfileForm(BuildContext context){
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 2.h, bottom: 0.5.h),
        child: ListView(
          children: [
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
      clearOption: false,
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

  Widget _updateButton(BuildContext context){
    return AppButton(
      onPressed: (){
        BlocProvider.of<UserBloc>(context).add(UpdateUserProfile(_name.text, _birth, _phone.text, _gender.dropDownValue!.name));
      },
      text: "Update",
    );
  }
}