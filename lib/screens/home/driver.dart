import 'package:flutter/material.dart';

import 'package:levaeu_app/components/appbar.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);
  static String routeName = "/home/driver";

  @override
  _DriverHomeState createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LevaEuAppBar(title: 'Motorista'),
      body: const Center(child: Text('motorista'))
    );
  }
}