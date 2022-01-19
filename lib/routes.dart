import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:levaeu_app/screens/home.dart';

import 'package:levaeu_app/screens/auth/reset_password.dart';
import 'package:levaeu_app/screens/auth/sign_in.dart';
import 'package:levaeu_app/screens/auth/sign_up.dart';

final Map<String, WidgetBuilder> routes = {
  Home.routeName: (context) => const Home(),
  SignIn.routeName: (context) => const SignIn(),
  SignUp.routeName: (context) => const SignUp(),
  ResetPassword.routeName: (context) => const ResetPassword(),
};