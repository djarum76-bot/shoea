import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/order/order_bloc.dart';
import 'package:shoea/bloc/shoe/shoe_bloc.dart';
import 'package:shoea/components/app_button.dart';
import 'package:shoea/components/widget/head_icon_text.dart';
import 'package:shoea/components/widget/vertical_barrier.dart';
import 'package:shoea/models/order_model.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/constants.dart';
import 'package:shoea/utils/currency_format.dart';
import 'package:shoea/utils/modal_dialog.dart';
import 'package:shoea/utils/routes.dart';
import 'package:shoea/utils/screen_argument.dart';

class OrderScreen extends StatefulWidget{
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late TextEditingController _review;
  final _formKey = GlobalKey<FormState>();
  double _rating = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _review = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _review.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<OrderBloc>(context)..add(OrderFetched()),
      child: Scaffold(
        body: _orderView(context),
      ),
    );
  }

  Widget _orderView(BuildContext context){
    final size = MediaQuery.of(context).size;
    return BlocListener<ShoeBloc, ShoeState>(
      listener: (context, state){
        if(state.status == ShoeStatus.error){
          EasyLoading.dismiss();
          ModalDialog.dangerDialog(context);
        }
        if(state.status == ShoeStatus.addReviewSuccess){
          BlocProvider.of<OrderBloc>(context).add(OrderFetched());
          EasyLoading.dismiss();
          Navigator.pop(context);
        }
        if(state.status == ShoeStatus.loading){
          EasyLoading.show(status: "Adding...",);
        }
      },
      child: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.fromLTRB(1.5.h, 1.5.h, 1.5.h, 0),
          child: Column(
            children: [
              headIconText(context, "My Orders"),
              _orderTabBar(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderTabBar(BuildContext context){
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state){
        if(state.status == OrderStatus.loading){
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }else if(state.status == OrderStatus.fetchSuccess){
          return Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  _orderTabBarTitle(),
                  _orderTabBarList(context)
                ],
              ),
            ),
          );
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

  Widget _orderTabBarTitle(){
    return TabBar(
      indicatorColor: AppTheme.primaryColor,
      labelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: AppTheme.primaryColor),
      unselectedLabelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: AppTheme.grayColor),
      labelColor: AppTheme.primaryColor,
      unselectedLabelColor: AppTheme.grayColor,
      tabs: const [
        Tab(text: "Active",),
        Tab(text: "Completed",),
      ],
    );
  }

  Widget _orderTabBarList(BuildContext context){
    return Expanded(
      child: TabBarView(
        children: [
          _orderActiveTabBar(context),
          _orderCompleteTabBar(context)
        ],
      ),
    );
  }

  Widget _orderActiveTabBar(BuildContext context){
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state){
        if(state.ordersActive.isEmpty){
          return Expanded(
            child: Center(
              child: Text(
                "No Active Order Found",
                style: GoogleFonts.urbanist(fontSize: 18.sp),
              ),
            ),
          );
        }else{
          return ListView.builder(
            itemCount: state.ordersActive.length,
            itemBuilder: (context, index){
              OrderModel order = state.ordersActive[index];
              return _orderItem(context, index, false, order, false);
            },
          );
        }
      },
    );
  }

  Widget _orderCompleteTabBar(BuildContext context){
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state){
        if(state.ordersCompleted.isEmpty){
          return Expanded(
            child: Center(
              child: Text(
                "No Complete Order Found",
                style: GoogleFonts.urbanist(fontSize: 18.sp),
              ),
            ),
          );
        }else{
          return ListView.builder(
            itemCount: state.ordersCompleted.length,
            itemBuilder: (context, index){
              OrderModel order = state.ordersCompleted[index];
              return _orderItem(context, index, true, order, false);
            },
          );
        }
      },
    );
  }

  Widget _orderItem(BuildContext context, int index, bool isCompleted, OrderModel order, bool isBottomSheet){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: index == 0 ? 0 :1.5.h),
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _orderImage(order),
          _orderInformation(context, isCompleted, order, isBottomSheet)
        ],
      ),
    );
  }

  Widget _orderImage(OrderModel order){
    return Container(
      height: 14.5.h,
      width: 16.h,
      margin: EdgeInsets.only(right: 1.h),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage("${Constants.baseURL}/${order.shoe!.image!}"),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(20)
      ),
    );
  }

  Widget _orderInformation(BuildContext context, bool isCompleted, OrderModel order, bool isBottomSheet){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _orderName(order),
          SizedBox(height: 1.h,),
          _orderColorSizeQty(order),
          SizedBox(height: 0.5.h,),
          _orderStatus(isCompleted),
          SizedBox(height: 1.h,),
          _orderPriceButton(context, isCompleted, order, isBottomSheet)
        ],
      ),
    );
  }

  Widget _orderName(OrderModel order){
    return Text(
      order.shoe!.title!,
      style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 18.sp),
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _orderColorSizeQty(OrderModel order){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Color(int.parse(order.color!)),
          radius: 1.1.h,
        ),
        SizedBox(width: 1.w,),
        verticalBarrier(),
        SizedBox(width: 1.w,),
        Text(
          "Size ${order.size!}",
          style: GoogleFonts.urbanist(color: AppTheme.grayColor),
        ),
        SizedBox(width: 1.w,),
        verticalBarrier(),
        SizedBox(width: 1.w,),
        Text(
          "Qty ${order.qty!}",
          style: GoogleFonts.urbanist(color: AppTheme.grayColor),
        )
      ],
    );
  }

  Widget _orderStatus(bool isCompleted){
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.formColor
            ),
            padding: EdgeInsets.all(1.h),
            child: Center(
              child: Text(
                isCompleted ? "Completed" : "In Delivery",
                style: GoogleFonts.urbanist(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(),
        )
      ],
    );
  }

  Widget _orderPriceButton(BuildContext context, bool isCompleted, OrderModel order, bool isBottomSheet){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            CurrencyFormat.convertToIdr(order.price! * order.qty!),
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 17.sp),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: _orderButton(context, isCompleted, order, isBottomSheet),
        )
      ],
    );
  }

  Widget _orderButton(BuildContext context, bool isCompleted, OrderModel order, bool isBottomSheet){
    if(order.isReviewed! || isBottomSheet){
      return const SizedBox();
    }else{
      return AppButton(
        height: 3.5.h,
        fontSize: 14.5.sp,
        onPressed: (){
          if(isCompleted){
            _reviewModal(context, order);
          }else{
            Navigator.pushNamed(
              context,
              Routes.trackOrderScreen,
              arguments: ScreenArgument<OrderModel>(order)
            );
          }
        },
        text: isCompleted ? "Leave Review" : "Track Order",
      );
    }
  }

  Future<void> _reviewModal(BuildContext context, OrderModel order)async{
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )
        ),
        builder: (context){
          return _reviewBottomSheet(context, order);
        }
    );
  }

  Widget _reviewBottomSheet(BuildContext context, OrderModel order){
    return Container(
      decoration: const BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
      ),
      padding: EdgeInsets.all(1.5.h),
      height: 54.h,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Leave a Review",
                  style: GoogleFonts.urbanist(fontSize: 18.5.sp, fontWeight: FontWeight.w700),
                ),
                const Divider(color: AppTheme.formColor, thickness: 2,),
                _orderItem(context, 0, true, order, true),
                const Divider(color: AppTheme.formColor, thickness: 2,),
                Text(
                  "How is your checkout?",
                  style: GoogleFonts.urbanist(fontSize: 18.5.sp, fontWeight: FontWeight.w700),
                ),
                Text(
                  "Please give rating & also your review...",
                  style: GoogleFonts.urbanist(),
                ),
                RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.w),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rating = rating;
                  },
                ),
                SizedBox(height: 1.h,),
                TextFormField(
                  controller: _review,
                  decoration: AppTheme.reviewDecoration(),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: ValidationBuilder().build(),
                ),
                SizedBox(height: 1.h,),
                const Divider(color: AppTheme.formColor, thickness: 2,),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        height: 5.h,
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        text: "Cancel",
                        textColor: AppTheme.primaryColor,
                        backgroundColor: AppTheme.formColor,
                      ),
                    ),
                    SizedBox(width: 3.w,),
                    Expanded(
                      child: AppButton(
                        height: 5.h,
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            BlocProvider.of<ShoeBloc>(context).add(
                              ShoeReviewAdded(order.id!, order.shoeId!, _rating, _review.text)
                            );
                          }
                        },
                        text: "Yes, Add Review",
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}