import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shoea/bloc/address/address_bloc.dart';
import 'package:shoea/bloc/auth/auth_bloc.dart';
import 'package:shoea/bloc/card/card_bloc.dart';
import 'package:shoea/bloc/cart/cart_bloc.dart';
import 'package:shoea/bloc/checkout/checkout_bloc.dart';
import 'package:shoea/bloc/order/order_bloc.dart';
import 'package:shoea/bloc/review/review_bloc.dart';
import 'package:shoea/bloc/shoe/shoe_bloc.dart';
import 'package:shoea/bloc/transaction/transaction_bloc.dart';
import 'package:shoea/bloc/user/user_bloc.dart';
import 'package:shoea/cubit/navbar_cubit.dart';
import 'package:shoea/repositories/address_repository.dart';
import 'package:shoea/repositories/auth_repository.dart';
import 'package:shoea/repositories/card_repository.dart';
import 'package:shoea/repositories/cart_repository.dart';
import 'package:shoea/repositories/checkout_repository.dart';
import 'package:shoea/repositories/order_repository.dart';
import 'package:shoea/repositories/review_repository.dart';
import 'package:shoea/repositories/shoe_repository.dart';
import 'package:shoea/repositories/transaction_repository.dart';
import 'package:shoea/repositories/user_repository.dart';
import 'package:shoea/utils/app_theme.dart';
import 'package:shoea/utils/list_view_behavior.dart';
import 'package:shoea/utils/routes.dart';

void main()async{
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
        )
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => CardRepository(),
        ),
        RepositoryProvider(
          create: (context) => AddressRepository(),
        ),
        RepositoryProvider(
          create: (context) => ShoeRepository(),
        ),
        RepositoryProvider(
          create: (context) => CartRepository(),
        ),
        RepositoryProvider(
          create: (context) => CheckoutRepository(),
        ),
        RepositoryProvider(
          create: (context) => OrderRepository(),
        ),
        RepositoryProvider(
          create: (context) => ReviewRepository(),
        ),
        RepositoryProvider(
          create: (context) => TransactionRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
              userRepository: RepositoryProvider.of<UserRepository>(context)
            ),
          ),
          BlocProvider(
            create: (context) => NavbarCubit(),
          ),
          BlocProvider(
            create: (context) => UserBloc(userRepository: RepositoryProvider.of<UserRepository>(context)),
          ),
          BlocProvider(
            create: (context) => CardBloc(cardRepository: RepositoryProvider.of<CardRepository>(context)),
          ),
          BlocProvider(
            create: (context) => AddressBloc(addressRepository: RepositoryProvider.of<AddressRepository>(context)),
          ),
          BlocProvider(
            create: (context) => ShoeBloc(
              shoeRepository: RepositoryProvider.of<ShoeRepository>(context),
              reviewRepository: RepositoryProvider.of<ReviewRepository>(context)
            ),
          ),
          BlocProvider(
            create: (context) => CartBloc(cartRepository: RepositoryProvider.of<CartRepository>(context)),
          ),
          BlocProvider(
            create: (context) => CheckoutBloc(
                orderRepository: RepositoryProvider.of<CheckoutRepository>(context),
                addressRepository: RepositoryProvider.of<AddressRepository>(context)
            ),
          ),
          BlocProvider(
            create: (context) => OrderBloc(
              orderRepository: RepositoryProvider.of<OrderRepository>(context),
              transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
            ),
          ),
          BlocProvider(
            create: (context) => ReviewBloc(reviewRepository: RepositoryProvider.of<ReviewRepository>(context)),
          ),
          BlocProvider(
            create: (context) => TransactionBloc(transactionRepository: RepositoryProvider.of<TransactionRepository>(context)),
          )
        ],
        child: ResponsiveSizer(
          builder: (context, orientation, screenType){
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.theme(),
              builder: EasyLoading.init(builder: (context, child){
                return ScrollConfiguration(
                  behavior: ListViewBehavior(),
                  child: child!,
                );
              }),
              onGenerateRoute: Routes.generateRoutes,
              initialRoute: Routes.splashScreen,
            );
          },
        ),
      ),
    );
  }
}