import 'package:flutter/material.dart';
import 'package:shoea/bloc/user/user_bloc.dart';
import 'package:shoea/models/address_model.dart';
import 'package:shoea/models/brand_model.dart';
import 'package:shoea/models/order_model.dart';
import 'package:shoea/models/transaction_model.dart';
import 'package:shoea/screens/check_screen.dart';
import 'package:shoea/screens/navbar/cart/checkout_screen.dart';
import 'package:shoea/screens/navbar/cart/confirm_payment_screen.dart';
import 'package:shoea/screens/navbar/cart/payment_method_screen.dart';
import 'package:shoea/screens/navbar/cart/shipping_address_screen.dart';
import 'package:shoea/screens/navbar/cart/shipping_type_screen.dart';
import 'package:shoea/screens/navbar/home/comment_screen.dart';
import 'package:shoea/screens/navbar/home/search_screen.dart';
import 'package:shoea/screens/navbar/home/shoe_screen.dart';
import 'package:shoea/screens/navbar/order/track_order_screen.dart';
import 'package:shoea/screens/navbar/profile/add_address_screen.dart';
import 'package:shoea/screens/navbar/profile/add_new_card_screen.dart';
import 'package:shoea/screens/navbar/profile/address_screen.dart';
import 'package:shoea/screens/navbar/home/brand_screen.dart';
import 'package:shoea/screens/navbar/profile/edit_address_screen.dart';
import 'package:shoea/screens/navbar/profile/edit_profile_screen.dart';
import 'package:shoea/screens/navbar/home/most_popular_screen.dart';
import 'package:shoea/screens/navbar/profile/payment_screen.dart';
import 'package:shoea/screens/navbar/wallet/transaction_history_screen.dart';
import 'package:shoea/screens/navbar/wallet/transaction_screen.dart';
import 'package:shoea/screens/register/create_pin_screen.dart';
import 'package:shoea/screens/register/fill_profile_screen.dart';
import 'package:shoea/screens/login/login_screen.dart';
import 'package:shoea/screens/navbar/navbar_screen.dart';
import 'package:shoea/screens/on_boarding_screen.dart';
import 'package:shoea/screens/register/register_screen.dart';
import 'package:shoea/screens/navbar/home/special_screen.dart';
import 'package:shoea/screens/splash/splash_screen.dart';
import 'package:shoea/screens/navbar/home/wishlist_screen.dart';
import 'package:shoea/utils/screen_argument.dart';

class Routes{
  static const splashScreen = "/splash";
  static const onBoardingScreen = "/on-boarding";
  static const loginScreen = "/login";
  static const registerScreen = "/register";
  static const fillProfileScreen = "/fill-profile";
  static const createPinScreen = "/create-pin";
  static const checkScreen = "/check";
  static const navbarScreen = "/navbar";
  static const editProfileScreen = "/edit-profile";
  static const addressScreen = "/address";
  static const paymentScreen = "/payment";
  static const wishlistScreen = "/wishlist";
  static const specialScreen = "/special";
  static const mostPopularScreen = "/most-popular";
  static const brandScreen = "/brand";
  static const searchScreen = "/search";
  static const shoeScreen = "/shoe";
  static const commentScreen = "/comment";
  static const checkoutScreen = "/checkout";
  static const shippingAddressScreen = "/shipping-address";
  static const shippingTypeScreen = "/shipping-type";
  static const addAddressScreen = "/add-address";
  static const editAddressScreen = "/edit-address";
  static const paymentMethodScreen = "/payment-method";
  static const confirmPaymentScreen = "/confirm-payment";
  static const trackOrderScreen = "/track-checkout";
  static const transactionHistoryScreen = "/transaction-history";
  static const transactionScreen = "/transaction";
  static const addNewCardScreen = "/add-new-card";

  static Route<dynamic>? generateRoutes(RouteSettings settings){
    switch(settings.name){
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case fillProfileScreen:
        return MaterialPageRoute(builder: (_) => const FillProfileScreen());
      case createPinScreen:
        return MaterialPageRoute(builder: (_) => const CreatePinScreen());
      case checkScreen:
        return MaterialPageRoute(builder: (_) => const CheckScreen());
      case navbarScreen:
        return MaterialPageRoute(builder: (_) => const NavbarScreen());
      case editProfileScreen:
        final args = settings.arguments as ScreenArgument<UserState>;
        return MaterialPageRoute(builder: (_) => EditProfileScreen(state: args.data,));
      case addressScreen:
        return MaterialPageRoute(builder: (_) => const AddressScreen());
      case paymentScreen:
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
      case wishlistScreen:
        return MaterialPageRoute(builder: (_) => const WishlistScreen());
      case specialScreen:
        return MaterialPageRoute(builder: (_) => const SpecialScreen());
      case mostPopularScreen:
        return MaterialPageRoute(builder: (_) => const MostPopularScreen());
      case brandScreen:
        final args = settings.arguments as ScreenArgument<BrandModel>;
        return MaterialPageRoute(builder: (_) => BrandScreen(brand: args.data,));
      case searchScreen:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case shoeScreen:
        return MaterialPageRoute(builder: (_) => const ShoeScreen());
      case commentScreen:
        final args = settings.arguments as ScreenArgument<List<dynamic>>;
        return MaterialPageRoute(builder: (_) => CommentScreen(shoeData: args.data,));
      case checkoutScreen:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case shippingAddressScreen:
        return MaterialPageRoute(builder: (_) => const ShippingAddressScreen());
      case shippingTypeScreen:
        final args = settings.arguments as ScreenArgument<String>;
        return MaterialPageRoute(builder: (_) => ShippingTypeScreen(destinationCityID: args.data));
      case addAddressScreen:
        return MaterialPageRoute(builder: (_) => const AddAddressScreen());
      case editAddressScreen:
        final args = settings.arguments as ScreenArgument<AddressModel>;
        return MaterialPageRoute(builder: (_) => EditAddresScreen(address: args.data,));
      case paymentMethodScreen:
        return MaterialPageRoute(builder: (_) => const PaymentMethodScreen());
      case confirmPaymentScreen:
        return MaterialPageRoute(builder: (_) => const ConfirmPaymentScreen());
      case trackOrderScreen:
        final args = settings.arguments as ScreenArgument<OrderModel>;
        return MaterialPageRoute(builder: (_) => TrackOrderScreen(order: args.data,));
      case transactionHistoryScreen:
        return MaterialPageRoute(builder: (_) => const TransactionHistoryScreen());
      case transactionScreen:
        final args = settings.arguments as ScreenArgument<TransactionModel>;
        return MaterialPageRoute(builder: (_) => TransactionScreen(transaction: args.data,));
      case addNewCardScreen:
        return MaterialPageRoute(builder: (_) => const AddNewCardScreen());
      default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(
            body: Center(
              child: Text("No route defined for ${settings.name}"),
            ),
          );
        });
    }
  }
}