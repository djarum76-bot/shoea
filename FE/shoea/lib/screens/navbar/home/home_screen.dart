import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/shoe/shoe_bloc.dart';
import 'package:shoea/bloc/user/user_bloc.dart';
import 'package:shoea/components/shoe_item.dart';
import 'package:shoea/models/brand_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/list_item.dart';
import 'package:shoea/utils/routes.dart';
import 'package:shoea/utils/screen_argument.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:sticky_headers/sticky_headers.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<ShoeBloc>(context)..add(ShoeFetched(Constants.brand, false)),
        ),
        BlocProvider.value(
          value: BlocProvider.of<UserBloc>(context)..add(UserFetched()),
        )
      ],
      child: Scaffold(
        body: GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);

            if(!currentFocus.hasPrimaryFocus){
              currentFocus.unfocus();
            }
          },
          child: _homeView(context),
        ),
      ),
    );
  }

  Widget _homeView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<ShoeBloc, ShoeState>(
      listener: (context, state){
        if(state.status == ShoeStatus.searchNavigation){
          Navigator.pushNamed(context, Routes.searchScreen);
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
          child: ListView(
            children: [
              _headerHome(context),
              _searchForm(),
              _specialOffer(),
              _carouselPromotion(context),
              _brandButton(),
              _mostPopular(context),
              Container(height: 2.5.h, color: AppTheme.backgroundColor,),
              StickyHeader(
                header: _brandFilter(context),
                content: _shoesCollection(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerHome(BuildContext context){
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 7.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _headerUser(context),
          _headerFavorite(context)
        ],
      ),
    );
  }

  Widget _headerUser(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state){
        if(state.user == null){
          return Expanded(
            child: SizedBox(
              height: 5.1.h,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _headerPhotoSkeleton(),
                  SizedBox(width: 2.w,),
                  _headerNameSkeleton()
                ],
              ),
            ),
          );
        }else{
          return Expanded(
            child: SizedBox(
              height: 5.1.h,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _headerPhoto(state),
                  SizedBox(width: 2.w,),
                  _headerName(state),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _headerPhoto(UserState state){
    return SizedBox(
      height: 5.1.h,
      width: 10.5.w,
      child: CircleAvatar(
        radius: 1.h,
        backgroundImage: NetworkImage("${Constants.baseURL}/${state.user!.picture!.string}"),
      ),
    );
  }

  Widget _headerPhotoSkeleton(){
    return SizedBox(
      height: 5.1.h,
      width: 10.5.w,
      child: SkeletonAnimation(
        shimmerColor: Colors.grey,
        shimmerDuration: 1000,
        child: Container(
          width: 5.1.h,
          height: 5.1.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.skeletonColor,
          ),
        ),
      ),
    );
  }

  Widget _headerName(UserState state){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Welcome",
            style: GoogleFonts.urbanist(fontSize: 16.sp),
          ),
          Text(
            state.user!.name!.string!,
            style: GoogleFonts.urbanist(fontSize: 17.5.sp, fontWeight: FontWeight.w700),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          )
        ],
      ),
    );
  }

  Widget _headerNameSkeleton(){
    return Expanded(
      child: SkeletonAnimation(
        shimmerColor: Colors.grey,
        shimmerDuration: 1000,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                color: AppTheme.skeletonColor,
              ),
            ),
            Expanded(
              child: Container(
                color: AppTheme.skeletonColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _headerFavorite(BuildContext context){
    return SizedBox(
      width: 4.h,
      height: 4.h,
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, Routes.wishlistScreen);
        },
        borderRadius: BorderRadius.circular(200),
        child: Icon(
          LineIcons.heart,
          size: 4.h,
        ),
      ),
    );
  }

  Widget _searchForm(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.5.h),
      child: TextFormField(
        decoration: AppTheme.inputPrefixDecoration(LineIcons.search, "Search", 12),
        readOnly: true,
        onTap: (){
          BlocProvider.of<ShoeBloc>(context).add(ShoeSearchNavigation());
        },
      ),
    );
  }

  Widget _specialOffer(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Special Offers",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.5.sp),
        ),
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, Routes.specialScreen);
          },
          borderRadius: BorderRadius.circular(200),
          child: Text(
            "See All",
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 17.sp),
          ),
        )
      ],
    );
  }

  Widget _carouselPromotion(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.5.h),
      child: CarouselSlider(
        items: ListItem.carouselItems.map((item){
          return _carouselItem(item);
        }).toList(),
        options: CarouselOptions(
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true
        ),
      ),
    );
  }

  Widget _carouselItem(String item){
    return InkWell(
      onTap: (){},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 4.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: AssetImage(item),
                fit: BoxFit.cover
            )
        ),
      ),
    );
  }

  Widget _brandButton(){
    return Wrap(
      children: _brandNavigation(),
    );
  }

  Widget _brandItem(BrandModel brand){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
          context,
          Routes.brandScreen,
          arguments: ScreenArgument<BrandModel>(brand)
        );
      },
      child: Container(
        width: 17.65.w,
        margin: EdgeInsets.only(right: brand.id! % 4 == 0 ? 0 : 4.h, bottom: 2.5.h),
        height: 11.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.formColor,
              radius: 4.h,
              child: Center(
                child: Icon(
                  brand.icon!,
                  color: AppTheme.primaryColor,
                  size: 5.h,
                ),
              ),
            ),
            Text(
              brand.name!,
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.sp),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _brandNavigation(){
    List<Widget> choices = [];

    for (var brand in ListItem.brandItem){
      choices.add(
          _brandItem(brand)
      );
    }

    return choices;
  }

  Widget _mostPopular(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Most Popular",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 18.5.sp),
        ),
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, Routes.mostPopularScreen);
          },
          borderRadius: BorderRadius.circular(200),
          child: Text(
            "See All",
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 17.sp),
          ),
        )
      ],
    );
  }

  Widget _brandFilter(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 5.h,
      color: AppTheme.backgroundColor,
      margin: EdgeInsets.only(bottom: 2.5.h),
      child: BlocBuilder<ShoeBloc, ShoeState>(
        builder: (context, state){
          return ListView(
            scrollDirection: Axis.horizontal,
            children: _brandChip(context, state),
          );
        },
      ),
    );
  }

  List<Widget> _brandChip(BuildContext context, ShoeState state){
    List<Widget> widget = [];

    for (var brand in ListItem.brandChip) {
      widget.add(
        Container(
          margin: EdgeInsets.only(left: brand.id! == 0 ? 0 : 1.h),
          child: ChoiceChip(
            label: Text(brand.name!),
            labelStyle: GoogleFonts.urbanist(color: state.selectedBrand == brand ? AppTheme.backgroundColor : AppTheme.primaryColor),
            selected: state.selectedBrand == brand,
            selectedColor: AppTheme.primaryColor,
            backgroundColor: AppTheme.backgroundColor,
            side: const BorderSide(color: AppTheme.primaryColor),
            onSelected: (selected){
              BlocProvider.of<ShoeBloc>(context).add(
                ShoeFetched(brand, false)
              );
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
        if(state.shoes.isEmpty){
          return SizedBox(
            width: double.infinity,
            height: 50.h,
            child: Center(
              child: Text(
                "No Shoes Found",
                style: GoogleFonts.urbanist(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
            ),
          );
        }else{
          return Wrap(
            children: _shoesList(context, state),
          );
        }
      },
    );
  }

  List<Widget> _shoesList(BuildContext context, ShoeState state){
    List<Widget> widget = [];

    for(var shoe in state.shoes){
      widget.add(
        ShoeItem(
          shoe: shoe,
          shoes: state.shoes,
          brand: state.selectedBrand,
          isFavorite: false,
        )
      );
    }

    return widget;
  }
}