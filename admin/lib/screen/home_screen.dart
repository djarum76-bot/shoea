import 'package:admin/screen/shoe_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute (
                builder: (BuildContext context) => const ShoeScreen(),
              )
            );
          },
          child: const Text("Add Shoe"),
        ),
      ),
    );
  }
}