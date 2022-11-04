
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/auth/auth_bloc.dart';
import 'package:shoea/bloc/user/user_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_icon_text.dart';
import 'package:shoea/cubit/navbar_cubit.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/modal_dialog.dart';
import 'package:shoea/utils/routes.dart';
import 'package:shoea/utils/screen_argument.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<UserBloc>(context)..add(UserFetched()),
      child: Scaffold(
        body: _profileView(context),
      ),
    );
  }

  Widget _profileView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state){
        if(state.status == AuthStatus.authError){
          EasyLoading.dismiss();
          ModalDialog.dangerDialog(context);
        }
        if(state.status == AuthStatus.unauthenticated){
          EasyLoading.dismiss();
          Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
          context.read<NavbarCubit>().changeTab(0);
        }
        if(state.status == AuthStatus.loading){
          EasyLoading.show(status: "Thank You:(");
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
          child: Column(
            children: [
              headIconText(context, "Profile"),
              _userProfile(),
              const Divider(color: AppTheme.formColor, thickness: 2,),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state){
                  return _profileItem(
                      context,
                          (){
                        Navigator.pushNamed(
                            context,
                            Routes.editProfileScreen,
                            arguments: ScreenArgument<UserState>(state)
                        );
                      },
                      LineIcons.user,
                      "Edit Profile"
                  );
                },
              ),
              _profileItem(
                  context,
                      (){
                    Navigator.pushNamed(context, Routes.addressScreen);
                  },
                  LineIcons.mapMarker,
                  "Address"
              ),
              _profileItem(
                  context,
                      (){
                    Navigator.pushNamed(context, Routes.paymentScreen);
                  },
                  LineIcons.wallet,
                  "Payment"
              ),
              _logoutItem(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _userProfile(){
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state){
        return Column(
          children: [
            _photoProfile(context, state),
            _profileData(state),
          ],
        );
      },
    );
  }

  Widget _photoProfile(BuildContext context, UserState state){
    if(state.user != null){
      return Padding(
        padding: EdgeInsets.only(top: 3.h),
        child: Align(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              _photoCircle(state),
              _photoButton(context),
            ],
          ),
        ),
      );
    }else{
      return Padding(
        padding: EdgeInsets.only(top: 3.h),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 10.h,
            width: 10.h,
            child: SkeletonAnimation(
              shimmerColor: Colors.grey,
              shimmerDuration: 1000,
              child: Container(
                width: 10.h,
                height: 10.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.skeletonColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _photoCircle(UserState state){
    return CircleAvatar(
      backgroundImage: NetworkImage("${Constants.baseURL}/${state.user!.picture!.string!}"),
      radius: 8.h,
    );
  }

  Widget _photoButton(BuildContext context){
    return Positioned(
      right: 3.w,
      bottom: 0.5.h,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: (){
          BlocProvider.of<UserBloc>(context).add(
            UpdateUserImage()
          );
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

  Widget _profileData(UserState state){
    if(state.user == null){
      return _profileInformationSkeleton();
    }else{
      return _profileInformation(state);
    }
  }

  Widget _profileInformation(UserState state){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Column(
        children: [
          Text(
            state.user!.name!.string!,
            style: GoogleFonts.urbanist(fontSize: 18.sp, fontWeight: FontWeight.w600),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
          Text(
            state.user!.phone!.string!,
            style: GoogleFonts.urbanist(fontSize: 16.sp, fontWeight: FontWeight.w500),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    );
  }

  Widget _profileInformationSkeleton(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: SkeletonAnimation(
        shimmerColor: Colors.grey,
        shimmerDuration: 1000,
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 2.h,
              color: AppTheme.skeletonColor,
            ),
            Container(
              width: 10.w,
              height: 2.h,
              color: AppTheme.skeletonColor,
            )
          ],
        ),
      ),
    );
  }

  Widget _profileItem(BuildContext context, void Function()? onTap, IconData icon, String label){
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 5.h,
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                    icon
                ),
                SizedBox(width: 2.w,),
                Text(
                  label,
                  style: GoogleFonts.urbanist(fontSize: 17.sp, fontWeight: FontWeight.w600),
                )
              ],
            ),
            const Icon(
              LineIcons.angleRight,
              color: AppTheme.primaryColor,
            )
          ],
        ),
      ),
    );
  }

  Widget _logoutItem(BuildContext context){
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        _logOutModal(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 5.h,
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              LineIcons.doorOpen,
              color: AppTheme.redColor,
            ),
            SizedBox(width: 2.w,),
            Text(
              "Logout",
              style: GoogleFonts.urbanist(fontSize: 17.sp, fontWeight: FontWeight.w600, color: AppTheme.redColor),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _logOutModal(BuildContext context)async{
    return showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )
        ),
        builder: (context){
          return _logOutBottomSheet(context);
        }
    );
  }

  Widget _logOutBottomSheet(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
      ),
      padding: EdgeInsets.all(1.5.h),
      height: 20.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Logout",
            style: GoogleFonts.urbanist(fontSize: 18.5.sp, fontWeight: FontWeight.w700, color: AppTheme.redColor),
          ),
          const Divider(color: AppTheme.formColor, thickness: 2,),
          Text(
            "Are you sure you want to log out?",
            style: GoogleFonts.urbanist(fontSize: 17.sp, fontWeight: FontWeight.w600),
          ),
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
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state){
                  return Expanded(
                    child: AppButton(
                      height: 5.h,
                      onPressed: (){
                        BlocProvider.of<AuthBloc>(context).add(
                          LogoutRequested()
                        );
                      },
                      text: "Yes, Logout",
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}