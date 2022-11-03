import 'package:admin/bloc/shoe/shoe_bloc.dart';
import 'package:admin/repository/shoe_repository.dart';
import 'package:admin/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ShoeRepository(),
      child: BlocProvider(
        create: (context) => ShoeBloc(shoeRepository: RepositoryProvider.of<ShoeRepository>(context)),
        child: MaterialApp(
          builder: EasyLoading.init(),
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}