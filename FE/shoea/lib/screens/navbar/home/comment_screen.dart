import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoea/bloc/review/review_bloc.dart';
import 'package:shoea/components/widget/head_text.dart';
import 'package:shoea/models/review_model.dart';
import 'package:shoea/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/list_item.dart';
import 'package:formz/formz.dart';

class CommentScreen extends StatelessWidget{
  const CommentScreen({super.key, required this.shoeData});
  final List<dynamic> shoeData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ReviewBloc>(context)..add(ReviewFetched(shoeData[0], "All")),
      child: Scaffold(
        body: _commentView(context),
      ),
    );
  }

  Widget _commentView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
        child: Column(
          children: [
            headText(context, "${shoeData[1]} (${NumberFormat.decimalPattern('in').format(shoeData[2])} reviews)"),
            _ratingFilter(context),
            _commentList(context)
          ],
        ),
      ),
    );
  }

  Widget _ratingFilter(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 4.5.h,
      color: AppTheme.backgroundColor,
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _ratingChip(context),
      ),
    );
  }

  List<Widget> _ratingChip(BuildContext context){
    List<Widget> widget = [];

    for (var rating in ListItem.ratingCollection) {
      widget.add(
          _ratingItem(rating, ListItem.ratingCollection)
      );
    }

    return widget;
  }

  Widget _ratingItem(String rating, List<String> ratings){
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state){
        return InkWell(
          onTap: (){
            BlocProvider.of<ReviewBloc>(context).add(ReviewFetched(shoeData[0], rating));
          },
          child: Container(
            decoration: BoxDecoration(
                color: rating == state.rating ? AppTheme.primaryColor : AppTheme.backgroundColor,
                border: Border.all(color: AppTheme.primaryColor),
                borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
            margin: EdgeInsets.only(left: ratings.indexOf(rating) == 0 ? 0 : 1.h),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LineIcons.star,
                    color: rating == state.rating ? AppTheme.backgroundColor : AppTheme.primaryColor,
                    size: 2.h,
                  ),
                  SizedBox(width: 1.w,),
                  Text(
                    rating,
                    style: GoogleFonts.urbanist(color: rating == state.rating ? AppTheme.backgroundColor : AppTheme.primaryColor, fontSize: 16.5.sp, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _commentList(BuildContext context){
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state){
        if(state.status.isSubmissionInProgress){
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }else if(state.status.isSubmissionSuccess){
          if(state.reviews.isEmpty){
            return Expanded(
              child: Center(
                child: Text(
                  "No Review Found",
                  style: GoogleFonts.urbanist(fontSize: 18.sp),
                ),
              ),
            );
          }else{
            return Expanded(
              child: ListView.builder(
                itemCount: state.reviews.length,
                itemBuilder: (context, index){
                  ReviewModel review = state.reviews[index];
                  return _commentItem(index, review);
                },
              ),
            );
          }
        }else{
          return Expanded(
            child: Center(
              child: Text(
                state.message ?? "Error Fetching Comment",
                style: GoogleFonts.urbanist(fontSize: 18.sp),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _commentItem(int index, ReviewModel review){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: index != 0 ? 2.h : 0, bottom: index == 9 ? 1.h : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _commentItemHeader(review),
          SizedBox(height: 1.5.h,),
          _commentItemBody(review),
          SizedBox(height: 0.5.h,),
          _commentItemFooter(review)
        ],
      ),
    );
  }

  Widget _commentItemHeader(ReviewModel review){
    return Row(
      children: [
        SizedBox(
          height: 5.1.h,
          width: 10.5.w,
          child: CircleAvatar(
            radius: 1.h,
            backgroundImage: NetworkImage("${Constants.baseURL}/${review.user!.picture!.string!}"),
          ),
        ),
        SizedBox(width: 1.5.w,),
        Expanded(
          child: Text(
            review.user!.name!.string!,
            style: GoogleFonts.urbanist(fontSize: 18.sp, fontWeight: FontWeight.w700),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 1.5.w,),
        Container(
          height: 4.h,
          width: 15.w,
          decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              border: Border.all(color: AppTheme.primaryColor),
              borderRadius: BorderRadius.circular(20)
          ),
          padding: EdgeInsets.all(0.5.h),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.star,
                  color: AppTheme.primaryColor,
                  size: 2.h,
                ),
                SizedBox(width: 1.w,),
                Text(
                  "${review.rating!.toInt()}",
                  style: GoogleFonts.urbanist(color:  AppTheme.primaryColor, fontSize: 16.5.sp, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _commentItemBody(ReviewModel review){
    return Text(
      review.comment!,
      style: GoogleFonts.urbanist(fontSize: 15.sp),
      textAlign: TextAlign.justify,
    );
  }

  Widget _commentItemFooter(ReviewModel review){
    return Text(
      timeago.format(review.createdAt!),
      style: GoogleFonts.urbanist(fontSize: 14.sp, color: AppTheme.grayColor),
    );
  }
}