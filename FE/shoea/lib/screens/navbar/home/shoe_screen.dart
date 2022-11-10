import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/cart/cart_bloc.dart';
import 'package:shoea/bloc/shoe/shoe_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/cubit/navbar_cubit.dart';
import 'package:shoea/models/help_model.dart';
import 'package:shoea/models/shoe_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/currency_format.dart';
import 'package:shoea/utils/modal_dialog.dart';
import 'package:shoea/utils/routes.dart';
import 'package:shoea/utils/screen_argument.dart';

class ShoeScreen extends StatelessWidget{
  const ShoeScreen({super.key, required this.helper});
  final HelpModel helper;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShoeBloc>(context)..add(ShoeDetailFetched(helper.shoeID)),
      child: MultiBlocListener(
        listeners: [
          BlocListener<CartBloc, CartState>(
            listener: (context, state){
              if(state.status == CartStatus.error){
                EasyLoading.dismiss();
                ModalDialog.dangerDialog(context);
              }
              if(state.status == CartStatus.addSuccess){
                EasyLoading.dismiss();
                context.read<NavbarCubit>().changeTab(1);
                Navigator.pushNamedAndRemoveUntil(context, Routes.navbarScreen, (route) => false);
              }
              if(state.status == CartStatus.addLoading){
                EasyLoading.show(status: "Adding...",);
              }
            },
          ),
          BlocListener<ShoeBloc, ShoeState>(
            listener: (context, state){
              EasyLoading.dismiss();
            },
          )
        ],
        child: WillPopScope(
          child: Scaffold(
            body: _shoeView(context),
          ),
          onWillPop: (){
            return Future.value(true);
          },
        ),
      )
    );
  }

  Widget _shoeView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ShoeBloc, ShoeState>(
      builder: (context, state){
        if(state.status == ShoeStatus.loading){
          return const SafeArea(
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor,),
            ),
          );
        }else if(state.status == ShoeStatus.fetchDetailShoeSuccess){
          if(state.shoe == null){
            return const SafeArea(
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor,),
              ),
            );
          }else{
            return SafeArea(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: ListView(
                  children: [
                    _shoeImageAndBack(context, state),
                    _shoeBody(context, state)
                  ],
                ),
              ),
            );
          }
        }else{
          return SafeArea(
            child: Center(
              child: Text(
                state.message ?? "Error",
                style: GoogleFonts.urbanist(fontSize: 18.sp),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _shoeImageAndBack(BuildContext context, ShoeState state){
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 42.5.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("${Constants.baseURL}/${state.shoe!.image!}"),
          fit: BoxFit.cover
        )
      ),
      padding: EdgeInsets.all(1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const CircleAvatar(
              backgroundColor: AppTheme.backgroundColor,
              child: Icon(
                  LineIcons.arrowLeft
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _shoeBody(BuildContext context, ShoeState state){
    return Padding(
      padding: EdgeInsets.all(1.5.h),
      child: Column(
        children: [
          _shoeNameFavorite(context, state),
          _shoeSoldRatingReview(context, state),
          Divider(color: AppTheme.grayColor.withOpacity(0.1), thickness: 1,),
          _shoeDescTitle(state),
          _shoeDescContent(state),
          _shoeSizeColor(context, state),
          _shoeQuantity(context, state),
          Divider(color: AppTheme.grayColor.withOpacity(0.1), thickness: 1,),
          _addToCart(context, state)
        ],
      ),
    );
  }

  Widget _shoeNameFavorite(BuildContext context, ShoeState state){
    return SizedBox(
      height: 3.5.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _shoeName(state),
          _shoeFavorite(context, state)
        ],
      ),
    );
  }

  Widget _shoeName(ShoeState state){
    return Expanded(
      child: Text(
        state.shoe!.title!,
        style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 20.sp),
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _shoeFavorite(BuildContext context, ShoeState state){
    return SizedBox(
      width: 3.h,
      height: 3.h,
      child: InkWell(
        onTap: (){
          if(state.favorite!.id! == 0){
            BlocProvider.of<ShoeBloc>(context).add(ShoeFavoriteAdded(helper));
          }else{
            BlocProvider.of<ShoeBloc>(context).add(ShoeFavoriteDeleted(state.favorite!.id!, helper));
          }
        },
        borderRadius: BorderRadius.circular(200),
        child: _isFavorite(state.favorite!.id!)
      ),
    );
  }

  Widget _isFavorite(int id){
    if(id == 0){
      return Icon(
        Icons.favorite_border,
        size: 3.h,
      );
    }else{
      return Icon(
        Icons.favorite,
        color: Colors.red,
        size: 3.h,
      );
    }
  }

  Widget _shoeSoldRatingReview(BuildContext context, ShoeState state){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      height: 3.95.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _shoeSold(state),
          SizedBox(width: 2.w,),
          _shoeRatingReview(context, state)
        ],
      ),
    );
  }

  Widget _shoeSold(ShoeState state){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppTheme.formColor
      ),
      padding: EdgeInsets.all(1.h),
      child: Center(
        child: Text(
          "${NumberFormat.decimalPattern('in').format(state.shoe!.sold!)} sold",
          style: GoogleFonts.urbanist(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _shoeRatingReview(BuildContext context, ShoeState state){
    return InkWell(
      onTap: (){
        if(state.shoe!.rating != 0 && state.shoe!.review != 0){
          Navigator.pushNamed(
            context,
            Routes.commentScreen,
            arguments: ScreenArgument<List<dynamic>>([state.shoe!.id!, state.shoe!.rating!, state.shoe!.review!])
          );
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Icon(LineIcons.star, size: 2.5.h,),
          SizedBox(width: 1.w,),
          Text(
            "${state.shoe!.rating} (${NumberFormat.decimalPattern('in').format(state.shoe!.review)} reviews)",
            style: GoogleFonts.urbanist(fontSize: 17.sp),
          )
        ],
      ),
    );
  }

  Widget _shoeDescTitle(ShoeState state){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Description",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
      ),
    );
  }

  Widget _shoeDescContent(ShoeState state){
    return ReadMoreText(
      state.shoe!.description!,
      trimLines: 2,
      textAlign: TextAlign.justify,
      colorClickableText: Colors.pink,
      trimMode: TrimMode.Line,
      trimCollapsedText: 'Show more',
      trimExpandedText: 'Show less',
      moreStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
      lessStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
      style: GoogleFonts.urbanist(),
    );
  }

  Widget _shoeSizeColor(BuildContext context, ShoeState state){
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 10.h,
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        children: [
          _shoeSize(context, state),
          SizedBox(width: 4.w,),
          _shoeColor(context, state)
        ],
      ),
    );
  }

  Widget _shoeSize(BuildContext context, ShoeState state){
    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Size",
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
            maxLines: 1,
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _shoeSizeChip(context, state),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _shoeSizeChip(BuildContext context, ShoeState state){
    List<Widget> widget = [];

    for (var size in state.shoe!.sizes!) {
      widget.add(
        _shoeSizeItem(size, state, context)
      );
    }

    return widget;
  }

  Widget _shoeSizeItem(Size size, ShoeState state, BuildContext context){
    return Container(
      height: 5.h,
      width: 5.h,
      margin: EdgeInsets.only(left: state.shoe!.sizes!.indexOf(size) == 0 ? 0 : 1.h),
      child: InkWell(
        onTap: (){
          BlocProvider.of<ShoeBloc>(context).add(ShoeSizeChanged(size));
        },
        borderRadius: BorderRadius.circular(200),
        child: Container(
          height: 5.h,
          width: 5.h,
          decoration: BoxDecoration(
              color: _backgroundColor(state, size),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryColor)
          ),
          child: Center(
            child: Text(
              size.int64!.toString(),
              style: GoogleFonts.urbanist(color: _textColor(state, size), fontSize: 16.5.sp),
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(ShoeState state, Size size){
    if(state.size == null){
      return AppTheme.backgroundColor;
    }else{
      if(state.size == size){
        return AppTheme.primaryColor;
      }else{
        return AppTheme.backgroundColor;
      }
    }
  }

  Color _textColor(ShoeState state, Size size){
    if(state.size == null){
      return AppTheme.primaryColor;
    }else{
      if(state.size == size){
        return AppTheme.backgroundColor;
      }else{
        return AppTheme.primaryColor;
      }
    }
  }

  Widget _shoeColor(BuildContext context, ShoeState state){
    return Expanded(
      flex: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Color",
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
            maxLines: 1,
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _shoeColorChip(context, state),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _shoeColorChip(BuildContext context, ShoeState state){
    List<Widget> widget = [];

    for (var color in state.shoe!.colors!) {
      widget.add(
        Container(
          margin: EdgeInsets.only(left: state.shoe!.colors!.indexOf(color) == 0 ? 0 : 1.h),
          child: InkWell(
            onTap: (){
              BlocProvider.of<ShoeBloc>(context).add(ShoeColorChanged(color));
            },
            borderRadius: BorderRadius.circular(200),
            child: CircleAvatar(
                backgroundColor: Color(int.parse(color)),
                child: state.color == color
                    ? _selectedShoeColor()
                    : const SizedBox()
            ),
          ),
        )
      );
    }

    return widget;
  }

  Widget _selectedShoeColor(){
    return const Center(
      child: Icon(LineIcons.check, color: AppTheme.backgroundColor,),
    );
  }

  Widget _shoeQuantity(BuildContext context, ShoeState state){
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Quantity",
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
          ),
          SizedBox(width: 3.w,),
          Container(
            decoration: BoxDecoration(
                color: AppTheme.formColor,
                borderRadius: BorderRadius.circular(8)
            ),
            padding: EdgeInsets.all(0.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    BlocProvider.of<ShoeBloc>(context).add(ShoeQtyDecreased());
                  },
                  borderRadius: BorderRadius.circular(200),
                  child: Icon(Ionicons.remove, size: 2.h,),
                ),
                SizedBox(width: 3.w,),
                Text(
                  state.qty.toString(),
                  style: GoogleFonts.urbanist(fontSize: 16.5.sp),
                ),
                SizedBox(width: 3.w,),
                InkWell(
                  onTap: (){
                    BlocProvider.of<ShoeBloc>(context).add(ShoeQtyIncreased());
                  },
                  borderRadius: BorderRadius.circular(200),
                  child: Icon(Ionicons.add, size: 2.h,),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _addToCart(BuildContext context, ShoeState state){
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      width: size.width,
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
                  CurrencyFormat.convertToIdr(state.shoe!.price! * state.qty),
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
                if(state.size == null){
                  ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(content: Text("Choose Size Please"))
                      );
                }else if(state.color == null){
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(content: Text("Choose Color Please"))
                    );
                }else{
                  BlocProvider.of<CartBloc>(context).add(CartAdded(state.shoe!.id!, state.color!, state.size!.int64!, state.qty));
                }
              },
              text: "Add to Cart",
            ),
          )
        ],
      ),
    );
  }
}