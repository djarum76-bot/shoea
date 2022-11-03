import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/shoe/shoe_bloc.dart';
import 'package:shoea/components/shoe_item.dart';
import 'package:shoea/utils/app_theme.dart';

class SearchScreen extends StatefulWidget{
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _search;
  late FocusNode _searchFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _search = TextEditingController();
    _searchFocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _search.dispose();
    _searchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _searchView(context),
    );
  }

  Widget _searchView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
        child: Column(
          children: [
            _searchForm(context),
            _bodySearch()
          ],
        ),
      ),
    );
  }

  Widget _searchForm(BuildContext context){
    return BlocBuilder<ShoeBloc, ShoeState>(
      builder: (context, state){
        return TextFormField(
          decoration: AppTheme.inputSuffixDecoration(LineIcons.search, "Search", 12),
          controller: _search,
          autofocus: true,
          focusNode: _searchFocus,
          onFieldSubmitted: (value){
            BlocProvider.of<ShoeBloc>(context).add(
                ShoeSearch(value)
            );
          },
          onChanged: (value){
            if(value == ""){
              BlocProvider.of<ShoeBloc>(context).add(
                ShoeSearch(value)
              );
            }
          },
        );
      },
    );
  }

  Widget _bodySearch(){
    return BlocBuilder<ShoeBloc, ShoeState>(
      builder: (context, state){
        switch(state.status){
          case ShoeStatus.initial:
            return Expanded(
              child: Column(
                children: [
                  _recentClearButton(),
                  _historySearch()
                ],
              ),
            );
          case ShoeStatus.data:
            return Expanded(
              child: Column(
                children: [
                  _resultFound(state, 13234),
                  _shoesData(state)
                ],
              ),
            );
          case ShoeStatus.noData:
            return Expanded(
              child: Column(
                children: [
                  _resultFound(state, 0),
                  _noShoesData()
                ],
              ),
            );
          case ShoeStatus.loading:
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            return Expanded(
              child: Center(
                child: Text(
                  "404 Error",
                  style: GoogleFonts.urbanist(fontSize: 19.h, fontWeight: FontWeight.w600),
                ),
              ),
            );
        }
      },
    );
  }

  Widget _recentClearButton(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Recent",
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.sp),
          ),
          InkWell(
            onTap: (){},
            borderRadius: BorderRadius.circular(200),
            child: Text(
              "Clear All",
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 17.sp),
            ),
          )
        ],
      ),
    );
  }

  Widget _historySearch(){
    return Expanded(
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index){
          return _historyItem();
        },
      ),
    );
  }

  Widget _historyItem(){
    return Container(
      margin: EdgeInsets.only(bottom: 0.25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                _search.text = "Adidas";
                _searchFocus.requestFocus();
              },
              child: Text(
                "Adidas",
                style: GoogleFonts.urbanist(color: AppTheme.grayColor),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: 4.h,
            height: 4.h,
            child: const Center(
              child: Icon(Ionicons.close_outline, color: AppTheme.grayColor,),
            ),
          )
        ],
      ),
    );
  }

  Widget _resultFound(ShoeState state, int found){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "Results for \"${state.search}\"",
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.sp),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 25.w,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${NumberFormat.decimalPattern('in').format(found)} found",
                style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 17.sp),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _shoesData(ShoeState state){
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
  }

  Widget _noShoesData(){
    return Expanded(
      child: Center(
        child: Lottie.asset("asset/lottie/nodata.json"),
      ),
    );
  }
}