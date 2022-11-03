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
    return Scaffold(
      body: _wishlistView(context),
    );
  }

  Widget _wishlistView(BuildContext context){
    final size = MediaQuery.of(context).size;
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
                  BlocProvider.of<ShoeBloc>(context).add(ShoeNavigation(Constants.brand));
                  Navigator.pop(context);
                }
            ),
            _brandFilter(context),
            _shoesCollection(context)
          ],
        ),
      ),
    );
  }

  Widget _brandFilter(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 4.5.h,
      color: AppTheme.backgroundColor,
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      child: BlocBuilder<ShoeBloc, ShoeState>(
        builder: (context, state){
          return ListView(
            scrollDirection: Axis.horizontal,
            children: _brandChip(context, state.selectedBrand),
          );
        },
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
                // BlocProvider.of<ShoeBloc>(context).add(
                //     ShoeFilter(brand)
                // );
              },
            ),
          )
      );
    }

    return widget;
  }

  Widget _shoesCollection(BuildContext context){
    return BlocBuilder<ShoeBloc, ShoeState>(
      builder: (context, state){
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
              );
            },
          ),
        );
      },
    );
  }
}