import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:levaeu_app/components/gradient_button.dart';
import 'package:levaeu_app/components/gradient_text.dart';
import 'package:levaeu_app/components/logo.dart';

import 'package:levaeu_app/screens/auth/sign_in.dart';
import 'package:levaeu_app/screens/auth/sign_up.dart';

import 'package:levaeu_app/theme.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);
  static String routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container (
          padding: const EdgeInsets.only(top: 10.0),
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              alignment: FractionalOffset.bottomCenter,
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Logo(),
                  SizedBox(height: ScreenUtil().screenHeight/4),
                  GradientButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignIn.routeName);
                    },
                    child: const Text('Entrar'),
                    borderRadius: BorderRadius.circular(50),
                    height: appButtonHeight,
                    gradient: appGradient,
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUp.routeName);
                    },
                    child: const GradientText(
                      'Cadastrar',
                      gradient: appGradient
                    ),
                    style: ButtonStyle(
                      backgroundColor:  MaterialStateProperty.all<Color>(appWhiteColor),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  const Text('Versão 1.0.0')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}