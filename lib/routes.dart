import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:levaeu_app/screens/home.dart';

import 'package:levaeu_app/screens/auth/reset_password.dart';
import 'package:levaeu_app/screens/auth/sign_in.dart';

final Map<String, WidgetBuilder> routes = {
  Home.routeName: (context) => const Home(),
  SignIn.routeName: (context) => const SignIn(),
  ResetPassword.routeName: (context) => const ResetPassword(),
};