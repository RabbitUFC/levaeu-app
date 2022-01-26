import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:levaeu_app/screens/home.dart';

import 'package:levaeu_app/screens/auth/sign_in.dart';
import 'package:levaeu_app/screens/auth/sign_up.dart';
import 'package:levaeu_app/screens/auth/recover_password.dart';
import 'package:levaeu_app/screens/auth/reset_password.dart';
import 'package:levaeu_app/screens/auth/confirm_account.dart';

import 'package:levaeu_app/screens/passenger/home.dart';

final Map<String, WidgetBuilder> routes = {
  Home.routeName: (context) => const Home(),
  SignIn.routeName: (context) => const SignIn(),
  SignUp.routeName: (context) => const SignUp(),
  RecoverPassword.routeName: (context) => const RecoverPassword(),
  ResetPassword.routeName: (context) => const ResetPassword(),
  ConfirmAccount.routeName: (context) => const ConfirmAccount(),
  PassengerHome.routeName: (context) => const PassengerHome(),
};