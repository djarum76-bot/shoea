import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shoea/cubit/navbar_cubit.dart';
import 'package:shoea/screens/navbar/cart/cart_screen.dart';
import 'package:shoea/screens/navbar/home/home_screen.dart';
import 'package:shoea/screens/navbar/order/order_screen.dart';
import 'package:shoea/screens/navbar/profile/profile_screen.dart';
import 'package:shoea/screens/navbar/wallet/wallet_screen.dart';

class NavbarScreen extends StatelessWidget{
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navbarBody(context),
      bottomNavigationBar: _navbarBottom(context),
    );
  }

  Widget _navbarBody(BuildContext context){
    return BlocBuilder<NavbarCubit, int>(
      builder: (context, state){
        return IndexedStack(
          index: state,
          children: const [
            HomeScreen(),
            CartScreen(),
            OrderScreen(),
            WalletScreen(),
            ProfileScreen()
          ],
        );
      },
    );
  }

  Widget _navbarBottom(BuildContext context){
    return BlocBuilder<NavbarCubit, int>(
      builder: (context, state){
        return FluidNavBar(
          icons: [
            FluidNavBarIcon(icon: LineIcons.home),
            FluidNavBarIcon(icon: LineIcons.shoppingCart),
            FluidNavBarIcon(icon: LineIcons.shoppingBag),
            FluidNavBarIcon(icon: LineIcons.wallet),
            FluidNavBarIcon(icon: LineIcons.user),
          ],
          defaultIndex: state,
          onChange: context.read<NavbarCubit>().changeTab,
        );
      },
    );
  }
}