
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/utils/list_item.dart';

class SpecialScreen extends StatelessWidget{
  const SpecialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _specialView(context),
    );
  }

  Widget _specialView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
        child: Column(
          children: [
            headText(context, "Special Offers"),
            _specialList(context)
          ],
        ),
      ),
    );
  }

  Widget _specialList(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 1.5.h),
        child: ListView.builder(
          itemCount: ListItem.carouselItems.length,
          itemBuilder: (context, index){
            return _specialItem(size, index, ListItem.carouselItems.length);
          },
        ),
      ),
    );
  }

  Widget _specialItem(Size size, int index, int length){
    return Container(
      width: size.width,
      height: 30.h,
      margin: EdgeInsets.only(top: index == 0 ? 0 : 1.5.h, bottom: index == length - 1 ? 1.5.h : 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              image: AssetImage(ListItem.carouselItems[index]),
              fit: BoxFit.cover
          )
      ),
    );
  }
}