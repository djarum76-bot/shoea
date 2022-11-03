import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/shoe/shoe_bloc.dart';
import 'package:shoea/models/shoe_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/currency_format.dart';
import 'package:shoea/utils/routes.dart';

class ShoeItem extends StatelessWidget{
  const ShoeItem({super.key, required this.shoe, required this.shoes, this.isGrid = false});

  final ShoeModel shoe;
  final bool isGrid;
  final List<ShoeModel> shoes;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        BlocProvider.of<ShoeBloc>(context).add(ShoeDetailFetched(shoe.id!));
        Navigator.pushNamed(context, Routes.shoeScreen);
      },
      child: Container(
        width: 45.1.w,
        height: 35.h,
        margin: isGrid ? EdgeInsets.only(bottom: shoes.indexOf(shoe) - shoes.length == -1 ? 0 : 2.5.h) : EdgeInsets.only(right: shoes.indexOf(shoe) % 2 == 1 ? 0 : 2.h, bottom: shoes.indexOf(shoe) - shoes.length == -1 ? 0 : 2.5.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _shoesImage(),
            _shoesInformation()
          ],
        ),
      ),
    );
  }

  Widget _shoesImage(){
    return Container(
      height: 23.h,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              image: NetworkImage("${Constants.baseURL}/${shoe.image}"),
              fit: BoxFit.cover
          )
      ),
    );
  }

  Widget _shoesInformation(){
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shoeName(),
            _shoeRatingSold(),
            _shoePrice()
          ],
        ),
      ),
    );
  }

  Widget _shoeName(){
    return Text(
      shoe.title!,
      style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
  }

  Widget _shoeRatingSold(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _shoeRating(),
        _shoeSold()
      ],
    );
  }

  Widget _shoeRating(){
    return Row(
      children: [
        Icon(LineIcons.star, size: 2.5.h,),
        SizedBox(width: 1.w,),
        Text(
          shoe.rating.toString(),
          style: GoogleFonts.urbanist(fontSize: 17.sp),
        )
      ],
    );
  }

  Widget _shoeSold(){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppTheme.formColor
      ),
      padding: EdgeInsets.all(1.h),
      child: Center(
        child: Text(
          "${NumberFormat.decimalPattern('in').format(shoe.sold)} sold",
          style: GoogleFonts.urbanist(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _shoePrice(){
    return Text(
      CurrencyFormat.convertToIdr(shoe.price!),
      style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.5.sp),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
  }
}