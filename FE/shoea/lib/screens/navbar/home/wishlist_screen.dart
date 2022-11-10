import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/shoe/shoe_bloc.dart';
import 'package:shoea/components/shoe_item.dart';
import 'package:shoea/components/widget/head_bloc_text.dart';
import 'package:shoea/models/brand_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/list_item.dart';

class WishlistScreen extends StatelessWidget{
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShoeBloc>(context)..add(ShoeFetched(Constants.brand, true)),
      child: WillPopScope(
        onWillPop: (){
          BlocProvider.of<ShoeBloc>(context).add(ShoeNavigation());
          return Future.value(true);
        },
        child: Scaffold(
          body: _wishlistView(context),
        ),
      ),
    );
  }

  Widget _wishlistView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ShoeBloc, ShoeState>(
      builder: (context, state){
        return SafeArea(
          child: Container(
            width: size.width,
            height: size.height,
            padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
            child: Column(
              children: [
                headBlocText(
                    context: context,
                    text: "My Wishlist",
                    onTap: (){
                      BlocProvider.of<ShoeBloc>(context).add(ShoeNavigation());
                      Navigator.pop(context);
                    }
                ),
                _brandFilter(context, state),
                _wishlistContent(context, state)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _wishlistContent(BuildContext context, ShoeState state){
    if(state.status == ShoeStatus.loading){
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else if(state.status == ShoeStatus.fetchAllShoeFavoriteSuccess || state.status == ShoeStatus.fetchBrandFavoriteSuccess || state.status == ShoeStatus.fetchDetailShoeSuccess){
      return _shoesCollection(context, state);
    }else{
      return Expanded(
        child: Center(
          child: Text(
            state.message ?? "Error",
            style: GoogleFonts.urbanist(fontSize: 18.sp),
          ),
        ),
      );
    }
  }

  Widget _brandFilter(BuildContext context, ShoeState state){
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 4.5.h,
      color: AppTheme.backgroundColor,
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _brandChip(context, state.selectedBrand),
      ),
    );
  }

  List<Widget> _brandChip(BuildContext context, BrandModel model){
    List<Widget> widget = [];

    for (var brand in ListItem.brandChip) {
      widget.add(
          Container(
            margin: EdgeInsets.only(left: brand.id! == 0 ? 0 : 1.h),
            child: ChoiceChip(
              label: Text(brand.name!),
              labelStyle: GoogleFonts.urbanist(color: model == brand ? AppTheme.backgroundColor : AppTheme.primaryColor),
              selected: model == brand,
              selectedColor: AppTheme.primaryColor,
              backgroundColor: AppTheme.backgroundColor,
              side: const BorderSide(color: AppTheme.primaryColor),
              onSelected: (selected){
                BlocProvider.of<ShoeBloc>(context).add(
                    ShoeFetched(brand, true)
                );
              },
            ),
          )
      );
    }

    return widget;
  }

  Widget _shoesCollection(BuildContext context, ShoeState state){
    if(state.shoes.isEmpty){
      return Expanded(
        child: Center(
          child: Text(
            "No Shoes Found",
            style: GoogleFonts.urbanist(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }else{
      return Expanded(
        child: GridView.builder(
          itemCount: state.shoes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 1.2.h,
              mainAxisExtent: 36.h
          ),
          itemBuilder: (context, index){
            var shoe = state.shoes[index];
            return ShoeItem(
              shoe: shoe,
              shoes: state.shoes,
              isGrid: true,
              brand: state.selectedBrand,
              isFavorite: true,
            );
          },
        ),
      );
    }
  }
}