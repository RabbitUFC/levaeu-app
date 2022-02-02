import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:levaeu_app/hive/user.dart';
import 'package:levaeu_app/screens/home/driver.dart';
import 'package:levaeu_app/screens/home/passenger.dart';

import 'package:levaeu_app/utils/hive.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(userBox).listenable(),
      builder: (BuildContext context, Box box, Widget? child) {
        User user = box.get('user');
        return user.selectedType == 'passenger'
          ? const PassengerHome()
          : const DriverHome();
      },
    );
  }
}