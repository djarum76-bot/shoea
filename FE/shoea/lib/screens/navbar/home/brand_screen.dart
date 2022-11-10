import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/shoe/shoe_bloc.dart';
import 'package:shoea/components/shoe_item.dart';
import 'package:shoea/components/widget/head_bloc_text.dart';
import 'package:shoea/models/brand_model.dart';

class BrandScreen extends StatelessWidget{
  const BrandScreen({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShoeBloc>(context)..add(ShoeFetched(brand, false)),
      child: WillPopScope(
        onWillPop: (){
          BlocProvider.of<ShoeBloc>(context).add(ShoeNavigation());
          return Future.value(true);
        },
        child: Scaffold(
          body: _brandView(context),
        ),
      ),
    );
  }

  Widget _brandView(BuildContext context){
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
                text: brand.name!,
                onTap: (){
                  BlocProvider.of<ShoeBloc>(context).add(ShoeNavigation());
                  Navigator.pop(context);
                }
            ),
            _shoesCollection(context)
          ],
        ),
      ),
    );
  }

  Widget _shoesCollection(BuildContext context){
    return BlocBuilder<ShoeBloc, ShoeState>(
      builder: (context, state){
        if(state.status == ShoeStatus.loading){
          return const Expanded(
            child: CircularProgressIndicator(),
          );
        }else if(state.status == ShoeStatus.fetchBrandSuccess || state.status == ShoeStatus.fetchDetailShoeSuccess){
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
              child: Padding(
                padding: EdgeInsets.only(top: 1.5.h),
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
                      isFavorite: false,
                    );
                  },
                ),
              ),
            );
          }
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
      },
    );
  }
}