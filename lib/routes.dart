import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:levaeu_app/screens/home.dart';

final Map<String, WidgetBuilder> routes = {
  Home.routeName: (context) => const Home(),
};