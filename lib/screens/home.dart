import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:levaeu_app/components/gradient_button.dart';
import 'package:levaeu_app/components/gradient_text.dart';

import 'package:levaeu_app/theme.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
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
                    SizedBox(
                      width: 150.w,
                      child: Image.asset('assets/logos/logo-2x.png'),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      width: appComponentsWidth,
                      child: Text(
                        'Caronas rápidas e seguras à um click de distância!',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal
                        )
                      ),
                    ),
                    SizedBox(height: ScreenUtil().screenHeight/4),
                    GradientButton(
                      onPressed: () {},
                      child: const Text('Entrar'),
                      borderRadius: BorderRadius.circular(50),
                      width: appComponentsWidth,
                      height: appButtonHeight,
                      gradient: appGradient,
                    ),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      onPressed: () {},
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