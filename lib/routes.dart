import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:levaeu_app/screens/initial_screen.dart';

import 'package:levaeu_app/screens/auth/sign_in.dart';
import 'package:levaeu_app/screens/auth/sign_up.dart';
import 'package:levaeu_app/screens/auth/recover_password.dart';
import 'package:levaeu_app/screens/auth/reset_password.dart';
import 'package:levaeu_app/screens/auth/confirm_account.dart';
import 'package:levaeu_app/screens/home/home.dart';
import 'package:levaeu_app/screens/home/home_pageview.dart';
import 'package:levaeu_app/screens/home/create_ride.dart';

final Map<String, WidgetBuilder> routes = {
  InitialScreen.routeName: (context) => const InitialScreen(),
  SignIn.routeName: (context) => const SignIn(),
  SignUp.routeName: (context) => const SignUp(),
  RecoverPassword.routeName: (context) => const RecoverPassword(),
  ResetPassword.routeName: (context) => const ResetPassword(),
  ConfirmAccount.routeName: (context) => const ConfirmAccount(),
  Home.routeName: (context) => const Home(),
  HomePageView.routeName: (context) => const HomePageView(),
  CreateRide.routeName: (context) => const CreateRide(),
};