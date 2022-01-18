import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Home',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold
            )
          ),
        ),
      ),
    );
  }
}