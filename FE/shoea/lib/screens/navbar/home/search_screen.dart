import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/shoe/shoe_bloc.dart';
import 'package:shoea/components/shoe_item.dart';
import 'package:shoea/models/history_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';

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
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _searchView(context),
      ),
      onWillPop: (){
        BlocProvider.of<ShoeBloc>(context).add(ShoeNavigation());

        return Future.value(true);
      },
    );
  }

  Widget _searchView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<ShoeBloc, ShoeState>(
      listener: (context, state){
        EasyLoading.dismiss();
      },
      child: SafeArea(
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
            if(value == ""){
              BlocProvider.of<ShoeBloc>(context).add(
                ShoeHistoryFetched()
              );
            }else{
              BlocProvider.of<ShoeBloc>(context).add(
                ShoeSearchFetched(value)
              );
            }
          },
          onChanged: (value){
            if(value == ""){
              BlocProvider.of<ShoeBloc>(context).add(
                ShoeHistoryFetched()
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
        if(state.status == ShoeStatus.fetchHistorySuccess || state.status == ShoeStatus.searchNavigation || state.status == ShoeStatus.initial){
          if(state.histories.isEmpty){
            return Expanded(
              child: Column(
                children: [
                  _recentClearButton(),
                  Expanded(
                    child: Center(
                      child: Text(
                        "No History Search",
                        style: GoogleFonts.urbanist(fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            );
          }else{
            return Expanded(
              child: Column(
                children: [
                  _recentClearButton(),
                  _historySearch()
                ],
              ),
            );
          }
        }else if(state.status == ShoeStatus.fetchSearchSuccess || state.status == ShoeStatus.fetchAllShoeSuccess || state.status == ShoeStatus.fetchBrandSuccess || state.status == ShoeStatus.fetchDetailShoeSuccess){
          if(state.shoes.isEmpty){
            return Expanded(
              child: Column(
                children: [
                  _resultFound(state, 0),
                  _noShoesData()
                ],
              ),
            );
          }else{
            return Expanded(
              child: Column(
                children: [
                  _resultFound(state, 13234),
                  _shoesData(state)
                ],
              ),
            );
          }
        }else if(state.status == ShoeStatus.loading){
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }else{
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
            onTap: (){
              BlocProvider.of<ShoeBloc>(context).add(ShoeHistoryDeletedAll());
            },
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
    return BlocBuilder<ShoeBloc, ShoeState>(
      builder: (context, state){
        return Expanded(
          child: ListView.builder(
            itemCount: state.histories.length,
            itemBuilder: (context, index){
              HistoryModel history = state.histories[index];
              return _historyItem(history);
            },
          ),
        );
      },
    );
  }

  Widget _historyItem(HistoryModel history){
    return Container(
      margin: EdgeInsets.only(bottom: 0.25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                _search.text = history.name;
                BlocProvider.of<ShoeBloc>(context).add(ShoeSearchFetched(history.name));
              },
              child: Text(
                history.name,
                style: GoogleFonts.urbanist(color: AppTheme.grayColor),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(200),
            onTap: (){
              BlocProvider.of<ShoeBloc>(context).add(ShoeHistoryDeleted(history.uuid));
            },
            child: SizedBox(
              width: 4.h,
              height: 4.h,
              child: const Center(
                child: Icon(Ionicons.close_outline, color: AppTheme.grayColor,),
              ),
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
                "${NumberFormat.decimalPattern('in').format(state.shoes.length)} found",
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
            brand: Constants.brand,
            isFavorite: false,
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